output "template" {
  value = data.template_file.lab_user_ssh_data.*.rendered
}