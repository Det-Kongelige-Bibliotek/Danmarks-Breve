module ApplicationHelper

  def translate_model_names(name)
    I18n.t("models.#{name}")
  end

  # Helper method to show the volume title at the letter index
  def show_volume_link args
    # Find the id of the volume in the letter's metadata
    id = args[:document]['volume_id_ssi']
    return unless id.present?
    # Use the Finder to get the document and its title
    title = Finder.get_doc_by_id(id).first['volume_title_ssim'].first
    # Make a link with the volume title as a label that redirects you to the volume landing page
    link_to title, solr_document_path(id)
    # In case we have no volume data we rescue
    rescue
  end

  def show_volume args
    id = args[:document]['volume_id_ssi']
    return unless id.present?
    link_to args[:value].first, solr_document_path(id)
  end

end
