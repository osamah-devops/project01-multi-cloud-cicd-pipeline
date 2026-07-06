resource "aws_ssm_document" "deploy_angular_app" {
  name          = "deploy-angular-app"
  document_type = "Command"

  content = <<EOF
{
  "schemaVersion": "2.2",
  "description": "Deploy Angular App",
  "mainSteps": [
    {
      "action": "aws:runShellScript",
      "name": "deployAngularApp",
      "inputs": {
        "runCommand": [
          "#!/bin/bash",
          "cd /var/www/html",
          "git clone https://github.com/<username>/<repo>.git /opt/app",
          "cd /opt/app",
          "npm install",
          "npm run build",
          "rm -rf /var/www/html/*",
          "cp -r dist/frontend/browser/* /var/www/html/",
          "systemctl restart httpd"
        ]
      }
    }
  ]
}
EOF
} 