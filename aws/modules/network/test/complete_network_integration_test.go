package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

const (
	region      = "us-west-2"
	vpcName     = "vpc-us-west-2-l-psi"
	keyPairname = "todo-bastion"
)

// M is an alias for map[string]interface{}
type LOM map[string]interface{}

func TestIntCompleteNetworkModule(t *testing.T) {
	keyPair := createAwsKeyPair(t)
	var bastionSSHUsers []LOM
	bastionSSHUsers = append(bastionSSHUsers, map[string]interface{}{
		"username":   "todoapp",
		"public_key": strings.Replace(keyPair.PublicKey, "\n", "", -1),
	})

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../example/complete-network/",
		Vars: map[string]interface{}{
			"bastion_ssh_users": bastionSSHUsers,
		},
	})

	defer aws.DeleteEC2KeyPair(t, keyPair)
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	vpcID := terraform.Output(t, terraformOptions, "vpc_id")

	//validate VPC
	vpc := aws.GetVpcById(t, vpcID, region)
	require.Equal(t, vpcName, vpc.Name) // assert vpc name

	// validate public subnets
	publicSubnets := terraform.OutputList(t, terraformOptions, "public_subnets")
	for _, subnet := range publicSubnets {
		aws.IsPublicSubnet(t, subnet, region) // check subnet is public or not
	}
	require.Equal(t, 2, len(publicSubnets)) // assert length

	//validate private subnets
	privateSubnets := terraform.OutputList(t, terraformOptions, "private_subnets")
	for _, subnet := range privateSubnets {
		assert.False(t, aws.IsPublicSubnet(t, subnet, region))
	}
	require.Equal(t, 2, len(privateSubnets)) // assert length

	//validate database subnets
	databaseSubnets := terraform.OutputList(t, terraformOptions, "database_subnets")
	for _, subnet := range databaseSubnets {
		assert.False(t, aws.IsPublicSubnet(t, subnet, region))
	}
	require.Equal(t, 2, len(databaseSubnets)) // assert length

	// //validate Internet gateway
	internetGatewayID := terraform.Output(t, terraformOptions, "igw_id")
	require.NotNil(t, internetGatewayID) // assert no nil

	// validate Database Subnet group
	databaseSubnetGroup := terraform.Output(t, terraformOptions, "database_subnet_group")
	require.Equal(t, vpcName, databaseSubnetGroup) // assert subnet group name

	// validate Nat gateway
	natGatewayIds := terraform.OutputList(t, terraformOptions, "natgw_ids")
	require.Equal(t, 1, len(natGatewayIds)) // assert subnet group name

	// Run perpetual diff
	// perpetualPlan := terraform.InitAndPlan(t, terraformOptions)
	// assert.Contains(t, perpetualPlan, "No changes. Infrastructure is up-to-date")

	bastionPublicIPs := terraform.OutputList(t, terraformOptions, "bastion_public_ips")
	for _, ip := range bastionPublicIPs {
		testSSHToBastion(t, terraformOptions, keyPair, "todoapp", ip)
	}

}

func createAwsKeyPair(t *testing.T) *aws.Ec2Keypair {
	keyPair := aws.CreateAndImportEC2KeyPair(t, region, keyPairname)
	return keyPair
}

func testSSHToBastion(t *testing.T, terraformOptions *terraform.Options, keyPair *aws.Ec2Keypair, sshuserName string, bastionPublicIP string) {

	publicHost := ssh.Host{
		Hostname:    bastionPublicIP,
		SshKeyPair:  keyPair.KeyPair,
		SshUserName: sshuserName,
	}
	maxRetries := 30
	timeBetweenRetries := 5 * time.Second
	description := fmt.Sprintf("SSH to public host %s@%s", sshuserName, bastionPublicIP)

	// Run a simple echo command on the server
	expectedText := "Hello, World"
	command := fmt.Sprintf("echo -n '%s'", expectedText)

	// Verify that we can SSH to the Instance and run commands
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		actualText, err := ssh.CheckSshCommandE(t, publicHost, command)

		if err != nil {
			return "", err
		}

		if strings.TrimSpace(actualText) != expectedText {
			return "", fmt.Errorf("Expected SSH command to return '%s' but got '%s'", expectedText, actualText)
		}

		return "", nil
	})
}
