module Utilities
    # Middleware for authentication
    def authenticated_user(req, res)
        unless req.session[:authenticated]
            res.status = 401
            res.write({ error: 'Unauthorized' }.to_json)
            halt(res.finish)
        end
    end

    def create_user(username, password)
        @users << { username: username, password: password }
        File.write('data/users.json', JSON.generate(@users))
    end

    def load_users
        users_file = File.join(__dir__, '..', 'data', 'users.json')
        if File.exist?(users_file)
            JSON.parse(File.read(users_file))
        else
            []
        end
    end

    def load_products
        products_file = File.join(__dir__, '..', 'data', 'products.json')
        if File.exist?(products_file)
            JSON.parse(File.read(products_file))
        else
            []
        end
    end
  
    def generate_random_id
        SecureRandom.hex(4)
    end
  
    def valid_product_data(data)
        !data['name'].nil? && !data['name'].empty?
    end
  
    def create_product(product_id, product_name)
        Thread.new do
            sleep(5)
            @products << { id: product_id, name: product_name }
            File.write('data/products.json', JSON.generate(@products))
        end
    end
  
    def respond_with_compression(req, res, content, content_type)
        if req.env['HTTP_ACCEPT_ENCODING']&.include?('gzip')
            res['Content-Encoding'] = 'gzip'
            res['Content-Type'] = content_type
            res.write(encode_with_gzip(content))
        else
            res['Content-Type'] = content_type
            res.write(content)
        end
    end
  
    def encode_with_gzip(content)
        StringIO.open do |io|
            gz = Zlib::GzipWriter.new(io)
            gz.write(content)
            gz.close
            io.string
        end
    end
end 
