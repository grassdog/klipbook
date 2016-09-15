# coding: utf-8
class MarkdownFile
  def initialize(book)
    @book = book
  end

  def save(output_dir, force, stream=$stdout)
    filepath = File.join(output_dir, filename)

    if !force && File.exists?(filepath)
      stream.puts(Colours.yellow("Skipping ") + filename)
      return
    end

    stream.puts(Colours.green("Writing ") + filename)
    File.open(filepath, 'w') do |f|
      write(f)
    end
  end

  private

  def write(file)
    file.puts "# #{@book.title}\n\n"
    file.puts "*by #{@book.author}*\n\n\n"

    @book.clippings
      .sort_by { |clipping| clipping.location || "" }
      .each do |clipping|
        text = clipping.text
        hl_url = clipping.location ? "[∞](kindle://book?action=open&asin=#{@book.asin}&location=#{clipping.location})" : ""

        file.puts "#{text.strip} #{hl_url}\n\n\n"
      end
  end

  def filename
    @book.title.gsub(/[:,\/!?]/, "") + ".md"
  end
end
