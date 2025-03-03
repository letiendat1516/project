/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Product;

/**
 *
 * @author IUHADU
 */
@WebServlet("/product-detail")
public class detailproduct extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Lấy ID sản phẩm từ tham số URL
            String productIdParam = request.getParameter("id");
            
            // Log để debug
            System.out.println("Requested Product ID: " + productIdParam);
            
            if (productIdParam == null || productIdParam.isEmpty()) {
                response.sendRedirect("products");
                return;
            }
            
            int productId = Integer.parseInt(productIdParam);
            
            // Gọi DAO để lấy thông tin sản phẩm
            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.getProductById(productId);
            
            // Log thông tin sản phẩm để debug
            if (product != null) {
                System.out.println("Product found: " + product.getName());
                System.out.println("Product ID: " + product.getProductId());
                System.out.println("Product Price: " + product.getPrice());
                System.out.println("Product Image URL: " + product.getImageUrl());
            } else {
                System.out.println("Product not found for ID: " + productId);
                response.sendRedirect("error.jsp?message=Product+not+found");
                return;
            }
            
            // Lấy danh sách sản phẩm liên quan (cùng danh mục)
            List<Product> relatedProducts = productDAO.getProductsByCategory(product.getCategoryId());
            // Loại bỏ sản phẩm hiện tại khỏi danh sách sản phẩm liên quan
            relatedProducts.removeIf(p -> p.getProductId() == product.getProductId());
            // Giới hạn số lượng sản phẩm liên quan
            if (relatedProducts.size() > 4) {
                relatedProducts = relatedProducts.subList(0, 4);
            }
            
            // Đặt thông tin vào request attribute
            request.setAttribute("product", product);
            request.setAttribute("relatedProducts", relatedProducts);
            
            // Forward request đến JSP
            request.getRequestDispatcher("/detailproduct.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            System.out.println("Invalid product ID format: " + e.getMessage());
            response.sendRedirect("error.jsp?message=Invalid+product+ID");
        } catch (Exception e) {
            System.out.println("Error loading product details: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=Error+loading+product");
        }
    }
}
