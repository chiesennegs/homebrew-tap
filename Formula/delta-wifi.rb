class DeltaWifi < Formula
  include Language::Python::Virtualenv

  desc "Monitor and recover Delta inflight Wi-Fi from the command line"
  homepage "https://github.com/chiesennegs/delta-wifi"
  url "https://github.com/chiesennegs/delta-wifi/releases/download/v0.3.0/delta-wifi-0.3.0-macos-universal.tar.gz"
  version "0.3.0"
  sha256 "b0dc87c72f4bd38ceda65d7cfbd51fe3814574459102ee72a2f94dcbdc83f4ca"
  license "MIT"

  depends_on :macos
  depends_on "python@3.13"

  def install
    venv = virtualenv_create(libexec, "python3.13")
    wheels = Dir["delta_wifi-*.whl"]
    odie "Expected exactly one application wheel" unless wheels.length == 1
    venv.pip_install_and_link wheels.first
    pkgshare.install "helpers"
    pkgshare.install "release-manifest.json"
    (bin/"delta-wifi").unlink
    (bin/"delta-wifi").write_env_script libexec/"bin/delta-wifi",
      DELTA_WIFI_BUNDLED_HELPERS: opt_pkgshare/"helpers"
  end

  def caveats
    <<~EOS
      Enable Wi-Fi name detection once:
        delta-wifi wifi-perms
      Optional alerts:
        delta-wifi notify-perms
      Credentials remain in macOS Keychain; preferences/history remain in your
      Application Support directory during upgrades and ordinary uninstalls.
      This formula installs HTTP mode. Browser mode is an optional Python extra.
    EOS
  end

  test do
    assert_match "delta-wifi 0.3.0", shell_output("#{bin}/delta-wifi --version")
    assert_match "logout", shell_output("#{bin}/delta-wifi --help")
  end
end
