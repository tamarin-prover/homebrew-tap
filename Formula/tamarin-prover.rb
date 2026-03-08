class TamarinProver < Formula
  desc "Automated security protocol verification tool"
  homepage "https://tamarin-prover.com/"
  url "https://github.com/tamarin-prover/tamarin-prover/archive/refs/tags/1.12.0.tar.gz"
  sha256 "35f0262e770db3632fcb297deb6ecc2d7c724c693fecfe97892e8224fa161956"
  head "https://github.com/tamarin-prover/tamarin-prover.git", branch: "master"

  bottle do
    root_url "https://github.com/tamarin-prover/tamarin-prover/releases/download/1.12.0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "936631c692ce9fd4c797400eff32e47d6d09e371ca251250cceac15b93f71d99"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "c4174f9f850d31243473d1bc8c04eb20117b28ec5a66276078768b58ef6ee9fd"
  end

  depends_on "haskell-stack" => :build
  depends_on "npm" => :build
  depends_on "graphviz"
  depends_on "maude"

  # doi "10.1109/CSF.2012.25"
  # tag "security"

  def install
    # make frontend
    system "make", "frontend"
    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    system "stack", "-j#{jobs}", "setup"
    args = []
    unless OS.mac?
      args << "--extra-include-dirs=#{Formula["zlib"].include}" << "--extra-lib-dirs=#{Formula["zlib"].lib}"
    end
    system "stack", "-j#{jobs}", *args, "install", "--flag", "tamarin-prover:threaded"

    bin.install Dir[".brew_home/.local/bin/*"]
  end

  test do
    system "#{bin}/tamarin-prover", "test"
  end
end
