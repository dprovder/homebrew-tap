class Kanstack < Formula
  desc "An unofficial kanban-style terminal UI for the GitButler CLI"
  homepage "https://github.com/dprovder/kanstack"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dprovder/kanstack/releases/download/v0.1.0/kanstack-aarch64-apple-darwin.tar.xz"
      sha256 "7ff1e0d3886043ba2edf9992dc53c7c218b9f507b25de7578f0fa915f03726e0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dprovder/kanstack/releases/download/v0.1.0/kanstack-x86_64-apple-darwin.tar.xz"
      sha256 "533b3e920a4b8814951c1698bfcc431e528027b961c71672d3708a6b4c93293c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dprovder/kanstack/releases/download/v0.1.0/kanstack-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "41e95b28f55cd03fb08a77c3c2d2ca10c0711bbfe6748d0f04b98c7272980278"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dprovder/kanstack/releases/download/v0.1.0/kanstack-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c882bd247ad2b27fa4b68e051caba90c04b340e2b25760f6e7af56645a069ed3"
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
    bin.install "kanstack" if OS.mac? && Hardware::CPU.arm?
    bin.install "kanstack" if OS.mac? && Hardware::CPU.intel?
    bin.install "kanstack" if OS.linux? && Hardware::CPU.arm?
    bin.install "kanstack" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
