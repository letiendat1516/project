/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import utils.Constants;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 *
 * @author IUHADU
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Validate input
        if (email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email và mật khẩu không được để trống");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.login(email, password);
            
            if (user != null) {
                // Kiểm tra trạng thái tài khoản
                if (!user.isIsActive()) {
                    request.setAttribute("error", "Tài khoản đã bị khóa");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                    return;
                }
                
                // Đăng nhập thành công
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("success", true);

                // Chuyển hướng dựa vào role
                switch (user.getRoleId()) {
                    case 1: // Admin
                        response.sendRedirect(request.getContextPath() + "/admin.jsp");
                        break;
                    case 2: // User thường
                        response.sendRedirect(request.getContextPath() + "/home");
                        break;
                    default:
                        response.sendRedirect(request.getContextPath() + "/home");
                }
            } else {
                // Đăng nhập thất bại
                request.setAttribute("error", "Email hoặc mật khẩu không đúng");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra trong quá trình đăng nhập");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra nếu đã đăng nhập thì chuyển hướng
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            // Chuyển hướng dựa vào role
            if (user.getRoleId() == 1) {
                response.sendRedirect(request.getContextPath() + "/admin.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
            return;
        }
        // Nếu chưa đăng nhập thì hiển thị trang login
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
