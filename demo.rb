require_relative 'lib/string_tree'

class Main
  def main(argc)
    puts "StringTree Ruby Demo"

    begin
      @st = StringTree.new
      puts "Loading Dictionary..."
      @count = 0
      File.open("dictionaries/5desk.txt", "r") do |infile|
        while line = infile.gets
          line = line.strip
          @st.add(line, @count+=1)
          @st.add(line.upcase, @count+=1)
        end
      end

      t=Time.now
      puts "Optimizing Dictionary..."
      @st.optimize
      puts "Optimized #{@count} entries in "+sprintf("%.2f",(Time.now-t)*1000)+"ms"

      load_hamlet
      do_match 'hamlet.tokens.txt'

      load_war_and_peace
      do_match 'warandpeace.tokens.txt'

      do_partial_matching
    rescue
      puts "StringTree has encountered an error. Please run again."
    end
  end

  def load_hamlet
    puts "-Loading Hamlet-------------------"
    load 'benchmark/hamlet.txt'
  end

  def load_war_and_peace
    puts "--Loading War And Peace-----------"
    load 'benchmark/warandpeace.txt'
  end

  def load(file_name)
    @contents = File.open(file_name,'rb').read
  end

  def do_match(output_file_name=nil)
    t=Time.now
    puts "Matching #{@count} entries in #{@contents.length} bytes..."
    list = []
    @st.match_all @contents, list
    interval = (Time.now-t)*1000

    puts list.length.to_s+" entities matched in "+sprintf("%.2f",interval)+"ms ("+sprintf("%.2f", list.length / interval * 1000)+" entities/s)"

    unless output_file_name.nil?
      puts "Writing File #{output_file_name}"
      File.open(output_file_name,'wb') do |f|
        list.each do |item|
          f.write item.offset.to_s + ": #{item.node} #{item.node.value} (#{item.node.strlength})\n"
        end
      end
    end
  end

  def do_partial_matching
    puts "-Partial Matching -----------------"
    puts "-Type 'exit' to quit"
    while true do
      print "> "
      x = gets.chomp
      return if x == 'exit'
      partials = @st.find_partial(x)
      str = ""
      unless partials.nil?
        partials.collect { |partial| str += partial[:key]+" " }
      else
        str =  "No Matches Found for '#{x}'"
      end
      puts str
    end
  end
end

@main = Main.new
@main.main(0)