require_relative 'utilities'

module Routes
    extend Utilities

    def self.define(app)
        app.instance_eval do
            on 'register' do
                on post do
                    req_body = req.body.read
                    data = JSON.parse(req_body)
            
                    username = data['username']
                    password = data['password']
            
                    if @users.any? { |user| user['username'] == username }
                        res.status = 400
                        response_json = { error: 'User already exists' }.to_json
                    else
                        create_user(username, password)
                        res.status = 201
                        response_json = { message: 'User created successfully' }.to_json
                    end

                    respond_with_compression(req, res, response_json, 'application/json')
                end
            end
        
            on 'authentication' do
                on post do
                    req_body = req.body.read
                    data = JSON.parse(req_body)
                
                    username = data['username']
                    password = data['password']
                
                    if @users.any? { |user| user['username'] == username && user['password'] == password }
                        req.session[:authenticated] = true
                        res.status = 200
                        response_json = { authenticated: true, message: 'User authenticated' }.to_json
                    else
                        res.status = 401 
                        response_json = { error: 'Invalid credentials' }.to_json
                    end

                    respond_with_compression(req, res, response_json, 'application/json')
                end
            end
        
            on 'products' do
                authenticated_user(req, res)
                on post, 'create' do
                    req_body = req.body.read
                    data = JSON.parse(req_body)
          
                    if valid_product_data(data)
                        product_id = generate_random_id
                        product_name = data['name']
                
                        if @products.any? { |product| product['id'] == product_id }
                            res.status = 400
                            response_json = { error: 'Generated product ID already exists' }.to_json
                        else
                            create_product(product_id, product_name)
                            res.status = 202
                            response_json = { message: 'Product creation started', product_id: product_id }.to_json
                        end
                    else
                        res.status = 400
                        response_json = { error: 'No name entered for the product' }.to_json
                    end

                    respond_with_compression(req, res, response_json, 'application/json')
                end
          
                on get do
                    products_json = JSON.generate(@products.map { |product| { id: product['id'], name: product['name'] } })
                    respond_with_compression(req, res, products_json, 'application/json')
                end
            end
        
            on 'openapi.yaml' do
                res['Cache-Control'] = 'no-cache, no-store, must-revalidate' # No Cache
                res['Pragma'] = 'no-cache'
                res['Expires'] = '0'
                res['Content-Type'] = 'text/yaml'
                response_json = File.read('config/openapi.yaml')
                respond_with_compression(req, res, response_json, 'text/yaml')
            end
        
            on 'AUTHORS' do
                res['Cache-Control'] = 'public, max-age=86400' # 24hs Cache
                res['Content-Type'] = 'text/plain'
                response_json = File.read('config/AUTHORS')
                respond_with_compression(req, res, response_json, 'text/plain')
            end
        
            on root do
                res.write('Welcome to the API!')
            end
        end
    end
end
