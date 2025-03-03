/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;
import dal.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Product;

/**
 *
 * @author IUHADU
 */
public class Search extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//    throws ServletException, IOException {
//        response.setContentType("text/html;charset=UTF-8");
//    String s  = request.getParameter("txt");
//    ProductDAO pd = new ProductDAO();
//    List<Product> list = pd.SearchProduct(s);
//    request.setAttribute("featuredProducts", list);
//    request.getRequestDispatcher("index.jsp").forward(request, response);
//    } 
//
//    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
//    /** 
//     * Handles the HTTP <code>GET</code> method.
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//    throws ServletException, IOException {
////        processRequest(request, response);
//    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override

protected void doPost(HttpServletRequest request, HttpServletResponse response)
throws ServletException, IOException {
    String s = request.getParameter("txt");
    String source = request.getParameter("source"); // Thêm tham số để biết nguồn
    
    if (s == null || s.trim().isEmpty()) {
        response.sendRedirect("products");
        return;
    }
    
    ProductDAO productDAO = new ProductDAO();
    List<Product> searchResults = productDAO.SearchProduct(s);
    
    if ("index".equals(source)) {
        // Nếu tìm kiếm từ trang chủ
        request.setAttribute("products", searchResults);
        request.setAttribute("searchQuery", s);
        request.getRequestDispatcher("product.jsp").forward(request, response);
    } else {
        // Nếu tìm kiếm từ trang product hoặc mặc định
        request.setAttribute("products", searchResults);
        request.setAttribute("searchQuery", s);
        request.getRequestDispatcher("product.jsp").forward(request, response);
    }
}


    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
