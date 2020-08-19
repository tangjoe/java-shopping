# Java Shopping Application

The application follows the microservices-style architect and consists of three applications, or services.

## shopfront

shopfront is Spring Boot-based application that has Web UI and acting as the main customer entry point.
[http://localhost:8010]

## productcatalogue

productcatalogue is an application provides data on the products.
[curl http://localhost:8020/products | jq]

## stockmanager

stockmanager is an application provides product stock data can be viewed as JSON format.
[curl http://localhost:8030/stocks | jq]

