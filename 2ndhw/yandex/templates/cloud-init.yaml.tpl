#cloud-config
write_files:
  - path: /var/www/html/index.html
    permissions: "0644"
    content: |
      <!DOCTYPE html>
      <html lang="ru">
      <head>
        <meta charset="UTF-8">
        <title>Netology HW — LAMP Instance Group</title>
      </head>
      <body>
        <h1>LAMP Instance Group</h1>
        <p>Картинка из Object Storage:</p>
        <p><a href="${image_url}">${image_url}</a></p>
        <img src="${image_url}" alt="homework picture" width="400">
      </body>
      </html>
runcmd:
  - systemctl restart apache2 || systemctl restart httpd
