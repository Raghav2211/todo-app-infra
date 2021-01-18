package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestIntCompleteNetworkModule(t *testing.T) {
	region := "us-west-2"

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../example/complete-network/",
	})
	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	vpcID := terraform.Output(t, terraformOptions, "vpc_id")
	// subnets := aws.GetSubnetsForVpc(t, vpcID, region)
	// require.Equal(t, 6, len(subnets))

	//validate VPC
	vpc := aws.GetVpcById(t, vpcID, region)
	require.Equal(t, "vpc-us-west-2-l-psi", vpc.Name)

	// validate public subnet
	publicSubnets := terraform.Output(t, terraformOptions, "public_subnets")

	// for _, subnet := range publicSubnets {
	// 	aws.IsPublicSubnet(t, subnet, region)
	// }

	fmt.Println("{} ", publicSubnets)

	// Run perpetual diff
	perpetualPlan := terraform.InitAndPlan(t, terraformOptions)
	assert.Contains(t, perpetualPlan, "0 to add, 14 to change, 0 to destroy")
}
