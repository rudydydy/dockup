defmodule Dockup.NginxConfig do
  def static_site_config(project_id, url) do
    """
    server {
      listen 80;

      root /dockup/#{project_id};
      index index.html;

      server_name #{url};

      location / {
        try_files $uri $uri/ =404;
      }
    }
    """
  end

  def hash(project_id) do
    :crypto.hash(:sha, project_id) |> Base.encode16
  end

  def config_file(project_id) do
    Path.join(Dockup.Configs.nginx_config_dir, hash(project_id))
  end

  def write_config(:static_site, project_id, haikunator \\ Dockup.Haikunator) do
    config = static_site_config(project_id, haikunator.haikunated_url)
    File.write(config_file(project_id), config)
  end
end