package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

type LOM map[string]interface{}

func TestUnitCompleteNetworkModule(t *testing.T) {
	t.Parallel()
	var bastionSSHUsers []LOM
	// support integration test case
	//so pass dummy bastion ssh user info
	bastionSSHUsers = append(bastionSSHUsers, map[string]interface{}{
		"username":   "todoapp",
		"public_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDkY5BBlQcj8BqUHPpFRvfX3VTyHa+BDdqZ2XtQW9N1CXQyt7RMc7TlT2oZVM41fEoNe9lRnP74WtIQ9qrVfStYO9+HELkGvhZzvjxlDdGy+V9FFX9M6MiJXcVO8arsk3rHjsPHpWaWFFBk+NC2wCL728OU1ci76w0F2VK8A/b3ppLqAUj1atV+q7Vn/TgAx5HwzDJg4f5jdzDwrdMmIcWnpdn8PX9CerjY7wi+8XBoO8Wpq5ozBDZco8/XRhyoIuA0PdDs/HjYMJZ94xubhb4Wg5zji+ZSFYBgG0OkHpRjPnYYg0U81h9HUJnep/OCJJZX+uL3yQItUe7TbFlUWLzJ",
	})

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../example/complete-network/",
		Vars: map[string]interface{}{
			"bastion_ssh_users": bastionSSHUsers,
		},
	})
	defer terraform.Destroy(t, terraformOptions)
	output := terraform.InitAndPlan(t, terraformOptions)
	assert.Contains(t, output, "27 to add, 0 to change, 0 to destroy")
}
