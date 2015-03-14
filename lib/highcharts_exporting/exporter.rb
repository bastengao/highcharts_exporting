require 'fileutils'
require 'tempfile'
require 'phantomjs'

# references:
#   http://www.highcharts.com/docs/export-module/export-module-overview
#   https://github.com/highslide-software/highcharts.com/tree/master/exporting-server/phantomjs
module HighchartsExporting
  module Exporter
    def export
      tmp_dir = Rails.root.join('tmp/highcharts').to_s
      FileUtils.mkdir_p tmp_dir

      @infile_tmp_file = nil
      if params[:options]
        @infile_tmp_file = Tempfile.new(['options', '.json'], tmp_dir)
        temp_write(@infile_tmp_file, params[:options])
      elsif params[:svg]
        @infile_tmp_file = Tempfile.new(['options', '.svg'], tmp_dir)
        temp_write(@infile_tmp_file, params[:svg])
      end


      infile_path = @infile_tmp_file.path
      type = params[:type] || 'image/png'
      extension = MIME::Types[type].first.extensions.first

      @output_tmp_file = Tempfile.new(['output', ".#{extension}"], tmp_dir)
      output_path = @output_tmp_file.path

      @callback_tmp_file = nil
      callback_path = if params[:callback]
                        @callback_tmp_file = Tempfile.new(['callbacks', '.js'], tmp_dir)
                        temp_write(@callback_tmp_file, params[:callback])
                        @callback_tmp_file.path
                      else
                        nil
                      end

      filename = params[:filename] || 'Chart'
      scale = params[:scale] || 2
      width = params[:width]
      constr = params[:constr] || 'Chart'

      convert_args = convert_args({
          infile: infile_path,
          outfile: output_path,
          scale: scale,
          width: width,
          constr: constr,
          callback: callback_path
      })

      result = ::Phantomjs.run(*convert_args)
      puts result if VERBOSE

      # TODO: clean @output_tmp_file
      @infile_tmp_file.delete
      @callback_tmp_file.delete if @callback_tmp_file

      if /Error/ =~ result
        render text: result, status: 500
      else
        send_file output_path, filename: "#{filename}.#{extension}", type: type
      end
    end

    protected
    def convert_args(args)
      convert_args = args.reject { |k, v| v.blank? }.to_a.map { |pair| ["-#{pair[0]}", pair[1].to_s] }.flatten

      convert_args.unshift("--web-security=false", convert_js_path)
    end

    def convert_js_path
      File.join(ROOT, 'phantomjs/highcharts-convert.js').to_s
    end

    def temp_write(tmp_file, content)
      File.open(tmp_file.path, 'r+') do |f|
        f.write content
      end
    end
  end
end