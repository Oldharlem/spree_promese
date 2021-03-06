module Promese
  class Client
    include Promese::Logging
    include HTTParty
    base_uri PromeseSetting.instance&.promese_endpoint

    def export_article(article)
      return unless PromeseSetting.instance.promese_endpoint.present?
      json = Promese::VariantSerializer.new(article).to_json
      resp = self.class.post('/logisticItem', body: json)
      if resp.success?
        logger.info "Exported #{article.class.to_s.demodulize} with sku #{article.sku}"
      else
        logger.error "Failed to export article with number #{article.sku}."
        logger.error "Response body: #{resp.body}"
        logger.error "Response status: #{resp.status}"
      end
    end

    def export_shipment(order)
      return unless PromeseSetting.instance.promese_endpoint.present?
      json = Promese::ShipmentSerializer.new(order).to_json
      resp = self.class.post('/outb2c', body: json)
      if resp.success?
        logger.info "Exported order with number #{order.number}"
      else
        logger.error "Failed to export order with number #{order.number}."
        logger.error "Response body: #{resp.body}"
        logger.error "Response status: #{resp.status}"
      end
    end

  end
end
