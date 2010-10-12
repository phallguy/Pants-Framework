#!/usr/local/bin/ruby
require 'fileutils'
require 'optparse'

options = {
  :image => 'Map.png',
  :levels => 6,
  :tileSize => 256,
  :output => nil,
  :screenSize => [320,480],
  :minscale => 0,
  :quiet => false,
  :quality => 70
}

o = OptionParser.new do |opts|
  
  opts.on( '-i', '--image PATH', 'The source image to tile.' ) {|v| options[:image] = v.strip }
  opts.on( '-o', '--output PATH', 'The base output path (ie. Map/Tile.jpg)' ) { |v| options[:output] = v.strip }
  opts.on( '-t', '--tile-size SIZE', Integer, 'The size of the tiles in pixels. Default is 256.' ) { |v| options[:tileSize] = v }
  opts.on( '-m', '--min-scale [SCALE]', Integer, 'The minimum scale to generate tiles for. Defaults 0.' ) { |v| options[:minscale] = v }
  opts.on( '-l', '--levles NUMBER', Integer, 'The number of detail levels to generate. Each level is scaled to 50% of the previous level.' ) do |v|
    options[:levles] = v
  end
  opts.on( 'q', '--quality QUALITY', Integer, 'The JPG quality for the output tiles.' ) { |v| options[:quality] = v }
  opts.on( '-v', '--[no-]verbose') { |v| options[:quiet] = !v }
  opts.on( '-s', '--screen-size WIDTH, HEIGHT', Array, 'Dimensions of the target screen. Defaults to 320x480') { |v| options[:screenSize] = v.map{ |x| x.to_i } }
  
  opts.on_tail( '-h', '--help', "Shows this text." ) do 
    puts opts
    exit
  end
  
end

o.parse!(ARGV)

options[:image] = 'Map.png' if ! options[:image]
options[:image] = File.expand_path( options[:image] )

options[:output] = File.join( File.dirname( options[:image] ), 'Map/Tile.jpg' ) if ! options[:output]
options[:output] = File.expand_path( options[:output] )

scales =   (options[:levels] - 1).downto(0).map { |x| 2**x }
tileSize = [options[:tileSize], options[:tileSize]]
maxscale = scales.max

tileFolder = File.dirname( options[:output] )

Dir.mkdir tileFolder if ! File.exists? tileFolder

scales.each do |scale|
  
  next if scale < options[:minscale]
  percent = ( scale / maxscale.to_f ) * 100
  
  scaleDir = File.join( tileFolder, "s#{percent.floor.to_i}/" )
  Dir.mkdir scaleDir if ! File.exist? scaleDir

  puts "Tiling scale #{scale}" if ! options[:quiet]
  
  tmpFile = File.join( scaleDir, "tmp.png" )
  
  if scale < maxscale
    puts "...scaling to #{percent}%"  if ! options[:quiet]
    system "convert -filter Lanczos -define filter:blur=1 -resize #{percent}% -unsharp 4x1 -quality 100 \"#{options[:image]}\" \"#{tmpFile}\""
  else
    FileUtils.cp options[:image], tmpFile
  end
    
  system "convert -crop #{tileSize[0]}x#{tileSize[1]} '#{tmpFile}' -quality #{options[:quality]} '#{scaleDir}/#{File.basename options[:output]}'"
  File.delete tmpFile
end

defaultFile = File.join( tileFolder, "Initial@2x.jpg" )
system "convert -filter Lanczos -define filter:blur=1 -resize 640x960 -unsharp 4x1 -quality 100 \"#{options[:image]}\" \"#{defaultFile}\""

defaultFile = File.join( tileFolder, "Initial.jpg" )
system "convert -filter Lanczos -define filter:blur=1 -resize 320x480 -unsharp 4x1 -quality 100 \"#{options[:image]}\" \"#{defaultFile}\""

