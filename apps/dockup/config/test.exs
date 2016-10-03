use Mix.Config

config :dockup,
  command_module: Dockup.FakeCommand,
  workdir: "test/fixtures/workdir",
  nginx_config_dir: "test/fixtures/nginx_config_dir",
  config_dir: "test/fixtures/dockup_config",
  skip_preflight_checks: true,
  start_server: false

config :logger, backends: []
