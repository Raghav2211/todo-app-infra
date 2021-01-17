package test

import (
	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
	"testing"
)

func TestBasicNetworkModuleExample(t *testing.T) {
	region := "us-west-2"
	varFiles := make([]string, 1, 1)
	varFiles[0] = "test/complete_network_example.tfvars"

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
		VarFiles:     varFiles,
	})
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	vpcId := terraform.Output(t, terraformOptions, "vpc_id")
	subnets := aws.GetSubnetsForVpc(t, vpcId, region)
	require.Equal(t, 6, len(subnets))
}
