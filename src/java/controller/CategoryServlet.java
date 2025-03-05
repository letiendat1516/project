package controller;

import dal.CategoryDAO;
import model.Category;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CategoryServlet", urlPatterns = {"/admin/categories"})
public class CategoryServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        CategoryDAO categoryDAO = new CategoryDAO();
        HttpSession session = request.getSession();
        
        switch (action) {
            case "list":
                listCategories(request, response, categoryDAO);
                break;
            case "add":
                addCategory(request, response, categoryDAO, session);
                break;
            case "edit":
                editCategory(request, response, categoryDAO);
                break;
            case "update":
                updateCategory(request, response, categoryDAO, session);
                break;
            case "delete":
                deleteCategory(request, response, categoryDAO, session);
                break;
            default:
                listCategories(request, response, categoryDAO);
        }
    }
    
    private void listCategories(HttpServletRequest request, HttpServletResponse response, CategoryDAO categoryDAO)
            throws ServletException, IOException {
        List<Category> categories = categoryDAO.getAllCategoriesWithProductCount();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);
    }
    
    private void addCategory(HttpServletRequest request, HttpServletResponse response, CategoryDAO categoryDAO, HttpSession session)
            throws ServletException, IOException {
        String categoryName = request.getParameter("categoryName");
        
        if (categoryName == null || categoryName.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Tên danh mục không được để trống");
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }
        
        // Kiểm tra tên danh mục đã tồn tại chưa
        if (categoryDAO.isCategoryNameExists(categoryName)) {
            session.setAttribute("errorMessage", "Tên danh mục đã tồn tại");
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }
        
        int categoryId = categoryDAO.addCategory(categoryName);
        if (categoryId > 0) {
            session.setAttribute("successMessage", "Thêm danh mục thành công");
        } else {
            session.setAttribute("errorMessage", "Thêm danh mục thất bại");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }
    
    private void editCategory(HttpServletRequest request, HttpServletResponse response, CategoryDAO categoryDAO)
            throws ServletException, IOException {
        int categoryId = Integer.parseInt(request.getParameter("id"));
        Category category = categoryDAO.getCategoryById(categoryId);
        
        if (category != null) {
            request.setAttribute("category", category);
            request.getRequestDispatcher("/admin/edit-category.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
        }
    }
    
    private void updateCategory(HttpServletRequest request, HttpServletResponse response, CategoryDAO categoryDAO, HttpSession session)
            throws ServletException, IOException {
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String categoryName = request.getParameter("categoryName");
        
        if (categoryName == null || categoryName.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Tên danh mục không được để trống");
            response.sendRedirect(request.getContextPath() + "/admin/categories?action=edit&id=" + categoryId);
            return;
        }
        
        // Kiểm tra tên danh mục đã tồn tại ở danh mục khác chưa
        if (categoryDAO.isCategoryNameExistsExcept(categoryName, categoryId)) {
            session.setAttribute("errorMessage", "Tên danh mục đã tồn tại");
            response.sendRedirect(request.getContextPath() + "/admin/categories?action=edit&id=" + categoryId);
            return;
        }
        
        boolean success = categoryDAO.updateCategory(categoryId, categoryName);
        if (success) {
            session.setAttribute("successMessage", "Cập nhật danh mục thành công");
        } else {
            session.setAttribute("errorMessage", "Cập nhật danh mục thất bại");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }
    
    private void deleteCategory(HttpServletRequest request, HttpServletResponse response, CategoryDAO categoryDAO, HttpSession session)
            throws ServletException, IOException {
        int categoryId = Integer.parseInt(request.getParameter("id"));
        
        // Kiểm tra xem danh mục có sản phẩm không
        if (categoryDAO.hasCategoryProducts(categoryId)) {
            session.setAttribute("errorMessage", "Không thể xóa danh mục đang có sản phẩm");
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }
        
        boolean success = categoryDAO.deleteCategory(categoryId);
        if (success) {
            session.setAttribute("successMessage", "Xóa danh mục thành công");
        } else {
            session.setAttribute("errorMessage", "Xóa danh mục thất bại");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Category Management Servlet";
    }
}
