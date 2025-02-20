<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="context.DBContext" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.security.SecureRandom" %>
<%@ page import="java.util.Base64" %>
<%@ page import="java.util.Properties" %>
<%@ page import="jakarta.mail.*" %>
<%@ page import="jakarta.mail.internet.*" %>
<%@ page import="jakarta.activation.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password | Toy Kingdom</title>
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
            background: linear-gradient(135deg, #c2e59c, #64b3f4);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .container {
            width: 100%;
            max-width: 450px;
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            padding: 40px 30px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .container:hover {
            transform: translateY(-5px);
            box-shadow: 0 25px 45px rgba(0, 0, 0, 0.15);
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
            font-size: 2em;
            font-weight: 600;
            position: relative;
            padding-bottom: 10px;
        }

        h2::after {
            content: '';
            position: absolute;
            left: 50%;
            bottom: 0;
            transform: translateX(-50%);
            height: 4px;
            width: 50px;
            background: linear-gradient(to right, #c2e59c, #64b3f4);
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
            font-size: 0.9em;
        }

        .form-group input {
            width: 100%;
            padding: 15px 45px;
            border: 2px solid #ddd;
            border-radius: 10px;
            font-size: 1em;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.9);
        }

        .form-group input:focus {
            border-color: #64b3f4;
            box-shadow: 0 0 15px rgba(100, 179, 244, 0.2);
            outline: none;
        }

        .form-group i {
            position: absolute;
            left: 15px;
            top: 42px;
            color: #666;
            font-size: 1.2em;
        }

        button {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #c2e59c, #64b3f4);
            border: none;
            border-radius: 10px;
            color: white;
            font-size: 1em;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(100, 179, 244, 0.4);
        }

        .message {
            padding: 15px 20px;
            margin-bottom: 25px;
            border-radius: 10px;
            font-size: 0.9em;
            display: flex;
            align-items: center;
        }

        .success {
            background-color: rgba(212, 237, 218, 0.9);
            color: #155724;
            border-left: 4px solid #28a745;
        }

        .error {
            background-color: rgba(248, 215, 218, 0.9);
            color: #721c24;
            border-left: 4px solid #dc3545;
        }

        .message i {
            margin-right: 10px;
            font-size: 1.2em;
        }

        @media (max-width: 480px) {
            .container {
                padding: 20px 15px;
            }

            h2 {
                font-size: 1.5em;
            }

            .form-group input {
                padding: 12px 40px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2><i class="fas fa-key"></i> Quên mật khẩu</h2>
        
        <%!
            public void sendEmail(String toEmail, String resetLink) throws Exception {
                final String fromEmail = "toykingdoms088@gmail.com";
                final String emailPassword = "kqjn zwmt ngsm korc";
                
                Properties props = new Properties();
                props.put("mail.smtp.host", "smtp.gmail.com");
                props.put("mail.smtp.port", "587");
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.starttls.enable", "true");
                
                Session session = Session.getInstance(props, new Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(fromEmail, emailPassword);
                    }
                });
                
                Message message = new MimeMessage(session);
                message.setFrom(new InternetAddress(fromEmail));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
                message.setSubject("Reset Password - Toy Kingdom");
                
                String emailContent = "Xin chào,<br><br>"
                    + "Bạn đã yêu cầu đặt lại mật khẩu cho tài khoản của mình.<br>"
                    + "Vui lòng click vào link dưới đây để đặt lại mật khẩu:<br><br>"
                    + "<a href='" + resetLink + "'>" + resetLink + "</a><br><br>"
                    + "Link này sẽ hết hạn sau 24 giờ.<br><br>"
                    + "Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.<br><br>"
                    + "Trân trọng,<br>Toy Kingdom";
                
                message.setContent(emailContent, "text/html; charset=UTF-8");
                Transport.send(message);
            }
        %>
        
        <%
            if (request.getMethod().equals("POST")) {
                String email = request.getParameter("email");
                String message = "";
                boolean isSuccess = false;

                try {
                    Connection conn = new DBContext().getConnection();
                    
                    String checkSql = "SELECT user_id FROM Users WHERE email = ? AND is_active = 1";
                    PreparedStatement checkPs = conn.prepareStatement(checkSql);
                    checkPs.setString(1, email);
                    ResultSet rs = checkPs.executeQuery();
                    
                    if (rs.next()) {
                        int userId = rs.getInt("user_id");
                        
                        byte[] bytes = new byte[32];
                        new SecureRandom().nextBytes(bytes);
                        String token = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
                        
                        String deleteSql = "DELETE FROM password_resets WHERE user_id = ?";
                        PreparedStatement deletePs = conn.prepareStatement(deleteSql);
                        deletePs.setInt(1, userId);
                        deletePs.executeUpdate();
                        
                        String insertSql = "INSERT INTO password_resets (user_id, token, expiry_date) VALUES (?, ?, DATEADD(HOUR, 24, GETDATE()))";
                        PreparedStatement insertPs = conn.prepareStatement(insertSql);
                        insertPs.setInt(1, userId);
                        insertPs.setString(2, token);
                        insertPs.executeUpdate();
                        
                        String resetLink = request.getScheme() + "://" + 
                                         request.getServerName() + ":" + 
                                         request.getServerPort() + 
                                         request.getContextPath() + 
                                         "/reset-password.jsp?token=" + token;
                        
                        sendEmail(email, resetLink);
                        
                        message = "Link reset đã được gửi tới email của bạn. Vui lòng kiểm tra email!";
                        isSuccess = true;
                        
                    } else {
                        message = "Email không tồn tại hoặc tài khoản đã bị vô hiệu hóa!";
                    }
                    
                    conn.close();
                    
                } catch (Exception e) {
                    message = "Lỗi: " + e.getMessage();
                    e.printStackTrace();
                }
                
                if (message != null && !message.isEmpty()) {
                    %>
                    <div class="message <%= isSuccess ? "success" : "error" %>">
                        <i class="fas fa-<%= isSuccess ? "check-circle" : "exclamation-circle" %>"></i>
                        <%= message %>
                    </div>
                    <%
                }
            }
        %>
        
        <form method="post" action="">
            <div class="form-group">
                <label for="email">Email của bạn</label>
                <input type="email" id="email" name="email" required 
                       placeholder="Nhập email đã đăng ký">
                <i class="fas fa-envelope"></i>
            </div>
            <button type="submit">
                <i class="fas fa-paper-plane"></i> Gửi yêu cầu khôi phục
            </button>
        </form>
    </div>
</body>
</html>
