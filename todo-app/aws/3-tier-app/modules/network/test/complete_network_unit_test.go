package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestBasicNetworkModuleExample(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../example/complete-network/",
	})
	defer terraform.Destroy(t, terraformOptions)
	output := terraform.InitAndPlan(t, terraformOptions)
	assert.Contains(t, output, "22 to add, 0 to change, 0 to destroy", "Plan OK and should attempt to create 22 resources")
}
