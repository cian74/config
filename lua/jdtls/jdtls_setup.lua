local M = {}

function M:setup()
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

  local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
  local launcher_path = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

  -- OS-specific config folder
  local os_name = vim.loop.os_uname().sysname
  local config_os = os_name == "Darwin" and "config_mac" or "config_linux"

  --  Force Java 21
  local java_bin = "/usr/lib/jvm/java-21-openjdk/bin/java"

  vim.env.JAVA_HOME = "/usr/lib/jvm/java-21-openjdk"
  vim.env.PATH = vim.env.JAVA_HOME .. "/bin:" .. vim.env.PATH

  local lombok_path = jdtls_path .. "/lombok.jar"
  if vim.fn.filereadable(lombok_path) == 0 then
    vim.fn.system({
      "curl",
      "-L",
      "-o",
      lombok_path,
      "https://projectlombok.org/downloads/lombok.jar",
    })
  end

  local config = {
    cmd = {
      java_bin,
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xmx2G",
      "--add-modules=ALL-SYSTEM",
      "--add-opens", "java.base/java.util=ALL-UNNAMED",
      "--add-opens", "java.base/java.lang=ALL-UNNAMED",
      "-javaagent:" .. lombok_path,
      "-jar", launcher_path,
      "-configuration", jdtls_path .. "/" .. config_os,
      "-data", workspace_dir,
    },

    root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml" }),

    settings = {
      java = {},
    },

    init_options = {
      bundles = {},
    },

    on_attach = function(client, bufnr)
      print(" JDTLS attached ")
    end,
  }

  require("jdtls").start_or_attach(config)
end

return M

