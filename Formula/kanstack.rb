class Kanstack < Formula
  desc "An unofficial kanban-style terminal UI for the GitButler CLI"
  homepage "https://github.com/dprovder/kanstack"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dprovder/kanstack/releases/download/v0.0.2/kanstack-aarch64-apple-darwin.tar.xz"
      sha256 "d408777e3c40953ff47ee553dc660e39c7d7a7875aac9ee350e24267481198a1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dprovder/kanstack/releases/download/v0.0.2/kanstack-x86_64-apple-darwin.tar.xz"
      sha256 "c296c41cad965d5f594a4c6602c51853fdca30b94984ba8b9afef276e1832cc1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dprovder/kanstack/releases/download/v0.0.2/kanstack-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "23620e2af30746324a414602608764f97b0cf69e2589cee92facef4fdba14b2d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dprovder/kanstack/releases/download/v0.0.2/kanstack-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "92e891454131532817d07a4c8d38a35deb2759c1d529ddcf06a2bc702110f361"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "kanstack"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "kanstack"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "kanstack"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "kanstack"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
