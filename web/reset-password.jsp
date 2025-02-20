<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="context.DBContext" %>
<%@ page import="utils.PasswordHash" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reset Password | Toy Kingdom</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .container {
            width: 100%;
            max-width: 450px;
            background: rgba(255, 255, 255, 0.95);
            padding: 40px 30px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            transition: all 0.3s ease;
        }

        .card-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .card-header h3 {
            color: #333;
            font-size: 2em;
            font-weight: 600;
            position: relative;
            padding-bottom: 15px;
        }

        .card-header h3::after {
            content: '';
            position: absolute;
            left: 50%;
            bottom: 0;
            transform: translateX(-50%);
            height: 4px;
            width: 50px;
            background: linear-gradient(to right, #667eea, #764ba2);
            border-radius: 2px;
        }

        .form-group {
            margin-bottom: 25px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
        }

        .form-group input {
            width: 100%;
            padding: 15px 45px;
            border: 2px solid #ddd;
            border-radius: 10px;
            font-size: 1em;
            transition: all 0.3s ease;
        }

        .form-group input:focus {
            border-color: #667eea;
            box-shadow: 0 0 15px rgba(102, 126, 234, 0.2);
            outline: none;
        }

        .form-group i {
            position: absolute;
            left: 15px;
            top: 42px;
            color: #666;
            font-size: 1.2em;
        }

        .password-toggle {
            position: absolute;
            right: 15px;
            top: 42px;
            color: #666;
            cursor: pointer;
        }

        .btn-submit {
            width: 100%;
            padding: 15px;
            background: linear-gradient(to right, #667eea, #764ba2);
            border: none;
            border-radius: 10px;
            color: white;
            font-size: 1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .alert {
            padding: 15px 20px;
            margin-bottom: 20px;
            border-radius: 10px;
            display: flex;
            align-items: center;
        }

        .alert i {
            margin-right: 10px;
            font-size: 1.2em;
        }

        .alert-danger {
            background-color: rgba(248, 215, 218, 0.9);
            color: #721c24;
            border-left: 4px solid #dc3545;
        }

        .alert-success {
            background-color: rgba(212, 237, 218, 0.9);
            color: #155724;
            border-left: 4px solid #28a745;
        }

        @media (max-width: 480px) {
            .container {
                padding: 20px 15px;
            }

            .card-header h3 {
                font-size: 1.5em;
            }
        }
    </style>
</head>
<body>
    <%
        String token = request.getParameter("token");
        String error = "";
        String success = "";
        Connection conn = null;
        
        if (request.getMethod().equals("POST")) {
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            
            if (!password.equals(confirmPassword)) {
                error = "Mật khẩu xác nhận không khớp!";
            } else {
                try {
                    DBContext db = new DBContext();
                    conn = db.getConnection();
                    
                    String sql = "SELECT pr.user_id, u.email FROM password_resets pr " +
                               "JOIN Users u ON pr.user_id = u.user_id " +
                               "WHERE pr.token = ? AND pr.expiry_date > GETDATE()";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setString(1, token);
                    ResultSet rs = ps.executeQuery();
                    
                    if (rs.next()) {
                        int userId = rs.getInt("user_id");
                        String email = rs.getString("email");
                        
                        String hashedPassword = PasswordHash.hashPassword(password);
                        
                        String updateSql = "UPDATE Users SET password = ? WHERE user_id = ?";
                        PreparedStatement updatePs = conn.prepareStatement(updateSql);
                        updatePs.setString(1, hashedPassword);
                        updatePs.setInt(2, userId);
                        updatePs.executeUpdate();
                        
                        String deleteTokenSql = "DELETE FROM password_resets WHERE token = ?";
                        PreparedStatement deletePs = conn.prepareStatement(deleteTokenSql);
                        deletePs.setString(1, token);
                        deletePs.executeUpdate();
                        
                        success = "Đặt lại mật khẩu thành công! Vui lòng đăng nhập lại.";
                        response.setHeader("Refresh", "3;url=login.jsp");
                    } else {
                        error = "Token không hợp lệ hoặc đã hết hạn!";
                    }
                } catch (Exception e) {
                    error = "Có lỗi xảy ra: " + e.getMessage();
                } finally {
                    if (conn != null) {
                        try {
                            conn.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
        }
    %>
    
    <div class="container">
        <div class="card-header">
            <h3><i class="fas fa-lock"></i> Đặt lại mật khẩu</h3>
        </div>
        
        <% if (!error.isEmpty()) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <%= error %>
            </div>
        <% } %>
        
        <% if (!success.isEmpty()) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <%= success %>
            </div>
        <% } else { %>
            <form method="post">
                <input type="hidden" name="token" value="<%= token %>">
                
                <div class="form-group">
                    <label>Mật khẩu mới</label>
                    <input type="password" name="password" required>
                    <i class="fas fa-key"></i>
                    <span class="password-toggle" onclick="togglePassword('password')">
                        
                    </span>
                </div>
                
                <div class="form-group">
                    <label>Xác nhận mật khẩu mới</label>
                    <input type="password" name="confirmPassword" required>
                    <i class="fas fa-lock"></i>
                    <span class="password-toggle" onclick="togglePassword('confirmPassword')">
                        
                    </span>
                </div>
                
                <button type="submit" class="btn-submit">
                    <i class="fas fa-save"></i> Đổi mật khẩu
                </button>
            </form>
        <% } %>
    </div>

    <script>
        function togglePassword(inputName) {
            const input = document.querySelector(`input[name="${inputName}"]`);
            const icon = input.nextElementSibling.nextElementSibling.querySelector('i');
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }

        document.querySelector('form').addEventListener('submit', function(e) {
            var password = document.querySelector('input[name="password"]').value;
            var confirmPassword = document.querySelector('input[name="confirmPassword"]').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Mật khẩu xác nhận không khớp!');
            }
        });
    </script>
</body>
</html>
