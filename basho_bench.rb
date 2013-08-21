require 'formula'

class BashoBench < Formula
  homepage 'https://github.com/basho/basho_bench'
  head "https://github.com/basho/basho_bench.git", :branch => "master"

  depends_on 'erlang-r15b01'
  depends_on 'r'

  def install
    system 'make all'

    system "install -d -m 000755 #{prefix}/bin"

    ['basho_bench', 'priv/compare.r', 'priv/gp_latencies.sh',
      'priv/gp_throughput.sh', 'priv/gp_throughput.sh'].each {|prog|
      system "install -p -m 000555 #{prog} #{prefix}/bin"
    }

    system "install -p -m 000444 priv/common.r #{prefix}/bin"

    # prime the needed R packages
    #
    # Probably shouldn't be done this way - atleast the packages are installed
    # into R's cellar.  These packages are left behind after
    # 'brew uninstall basho_bench'
    puts "Installing required R packages"
    system "Rscript --vanilla #{prefix}/bin/common.r"
  end

  def caveats; <<-EOS.undent
    This is a HEAD only formula.
    EOS
  end
end
