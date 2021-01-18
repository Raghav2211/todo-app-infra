package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestIntCompleteNetworkModule(t *testing.T) {
	region := "us-west-2"
	vpcName := "vpc-us-west-2-l-psi"

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../example/complete-network/",
	})
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
	require.Equal(t, 2, len(privateSubnets)) // assert length

	//validate database subnets
	databaseSubnets := terraform.OutputList(t, terraformOptions, "database_subnets")
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
	perpetualPlan := terraform.InitAndPlan(t, terraformOptions)
	assert.Contains(t, perpetualPlan, "0 to add, 14 to change, 0 to destroy")
}
