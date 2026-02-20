class Maude < Formula
  desc "Reflective language for equational and rewriting logic specification"
  homepage "http://maude.cs.illinois.edu"
  url "https://github.com/maude-lang/Maude/archive/refs/tags/Maude3.5.1.tar.gz" 
  sha256 "3dce4f7b42fae2430a08ab2663303d1be244792bb3cc365c58cdb2f3f7bff170" 
  revision 1

  bottle do
    root_url "https://raw.githubusercontent.com/tamarin-prover/binaries/HEAD/dependencies"
    sha256 cellar: :any, arm64_tahoe: "711887bd8107ad0f476d29e67f7760f6bea0724281799a13263c2428cd5f306c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3a941ae6e9eaa567827959dcac44129166c87b020d238c742c32467980e99936"
  end

  depends_on "gmp"
  depends_on "libbuddy"
  depends_on "libsigsegv"
  depends_on "libtecla"
  depends_on "flex" unless OS.mac?
  depends_on "bison" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    ENV.deparallelize
    system "autoreconf", "-vfi"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{libexec}",
                          "--without-cvc4",
                          "--without-yices2"
    system "make", "install"
    (bin/"maude").write_env_script libexec/"bin/maude", MAUDE_LIB: libexec/"share"
  end

  test do
    input = <<~EOS
      set show stats off .
      set show timing off .
      set show command off .
      reduce in STRING : "hello" + " " + "world" .
    EOS
    expect = %Q(Maude> result String: "hello world"\nMaude> Bye.\n)
    output = pipe_output("#{bin/"maude"} -no-banner", input)
    assert_equal expect, output
  end
end
