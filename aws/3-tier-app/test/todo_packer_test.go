package test

import (
	"testing"
	"time"

	terratest_aws "github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/packer"
)

var DefaultRetryablePackerErrors = map[string]string{
	"Script disconnected unexpectedly":                                                 "Occasionally, Packer seems to lose connectivity to AWS, perhaps due to a brief network outage",
	"can not open /var/lib/apt/lists/archive.ubuntu.com_ubuntu_dists_xenial_InRelease": "Occasionally, apt-get fails on ubuntu to update the cache",
}

const (
	DefaultTimeBetweenPackerRetries = 15 * time.Second
	DefaultMaxPackerRetries         = 3
	awsRegion                       = "us-west-2"
	todoAppVersion                  = "1.0.0"
)

func TestTodoPacker(t *testing.T) {
	packerOptions := &packer.Options{
		Template:   "app.json",
		WorkingDir: "../packer/todo/",
		Env: map[string]string{
			"AWS_REGION":  awsRegion,
			"APP_VERSION": todoAppVersion,
		},
		RetryableErrors:    DefaultRetryablePackerErrors,
		TimeBetweenRetries: DefaultTimeBetweenPackerRetries,
		MaxRetries:         DefaultMaxPackerRetries,
	}

	amiID := packer.BuildArtifact(t, packerOptions)

	defer terratest_aws.DeleteAmiAndAllSnapshots(t, awsRegion, amiID)

}
