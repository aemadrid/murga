module Murga
  module Handler
    class Default
      def self.handle(ctx)
        ctx.response.status(404).send
      end
    end
  end
end
