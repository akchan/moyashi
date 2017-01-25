module ApplicationHelper
  def options_for_spectrum_importer(importer_params)
    fields_for 'spectrum_importer_options', importer_params do |f|
      html = String.new
      importer_params.each do |name, value, type, options|
        html << content_tag(:div, class: 'uk-form-row'){
          f.label(name, class: 'uk-form-label') \
          + content_tag(:div, class: 'uk-form-controls'){
            case type
            when :integer, :float, :string
              f.text_field name
            when :boolean
              f.check_box name
            when :file
              f.file_field name
            when :select
              f.select name, options_for_select(options[:collection])
            end
          }
        }
      end
      html.html_safe
    end
  end


  def options_for_spectrum_exporter(exporter_params)
    fields_for "export[options]", exporter_params do |f|
      html = String.new
      exporter_params.each do |name, value, type, options|
        html << content_tag(:div, class: 'uk-form-row'){
          f.label(name, class: 'uk-form-label') \
          + content_tag(:div, class: 'uk-form-controls'){
            case type
            when :integer, :float, :string
              f.text_field name
            when :boolean
              f.check_box name
            when :file
              f.file_field name
            when :select
              f.select name, options_for_select(options[:collection])
            end
          }
        }
      end
      html.html_safe
    end
  end


  def options_for_analysis(analysis_params)
    fields_for "analysis_options", analysis_params do |f|
      html = String.new
      analysis_params.each do |name, value, type, options|
        html << content_tag(:div, class: 'uk-form-row'){
          f.label(name, class: 'uk-form-label') \
          + content_tag(:div, class: 'uk-form-controls'){
            case type
            when :integer, :float, :string
              f.text_field name
            when :boolean
              f.check_box name
            when :file
              f.file_field name
            when :select
              f.select name, options_for_select(options[:collection])
            end
          }
        }
      end
      html.html_safe
    end
  end
end