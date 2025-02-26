<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Properties" %>
<%@ page import="jakarta.mail.*" %>
<%@ page import="jakarta.mail.internet.*" %>
<%@ page import="jakarta.activation.*" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Liên Hệ | Kingdoms Toys</title>

        <!-- Favicon -->
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/images/favicon.png" type="image/x-icon">

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <!-- AOS Animation CSS -->
        <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

        <!-- Custom CSS -->
        <style>
            :root {
                --primary-color: #FF6B6B;
                --secondary-color: #4ECDC4;
                --accent-color: #FFE66D;
                --text-color: #2D3748;
                --light-color: #F7FAFC;
                --dark-color: #1A202C;
                --success-color: #48BB78;
                --error-color: #F56565;
            }

            

            /* Responsive Adjustments */
            @media (max-width: 991.98px) {
                .navbar-collapse {
                    background: white;
                    padding: 1rem;
                    border-radius: 10px;
                    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                    margin-top: 1rem;
                }

                .search-form {
                    margin: 1rem 0;
                    max-width: 100%;
                }

                .navbar-nav {
                    text-align: center;
                }

                .navbar-nav .nav-link::before {
                    bottom: -2px;
                }

                .navbar-nav .auth-links .nav-link {
                    margin: 5px 0;
                }
            }


            .page-header {
                background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
                color: white;
                padding: 80px 0;
                text-align: center;
                margin-bottom: 50px;
            }

            .page-header h1 {
                font-size: 3rem;
                font-weight: 700;
                margin-bottom: 20px;
            }

            .breadcrumb {
                background: transparent;
                justify-content: center;
            }

            .breadcrumb-item a {
                color: white;
                text-decoration: none;
            }

            .contact-section {
                padding: 50px 0 80px;
            }

            .contact-box {
                background-color: #fff;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                padding: 40px;
                height: 100%;
                transition: transform 0.3s ease;
            }

            .contact-box:hover {
                transform: translateY(-10px);
            }

            .contact-icon {
                width: 80px;
                height: 80px;
                background-color: rgba(255, 107, 107, 0.1);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 20px;
                color: var(--primary-color);
                font-size: 2rem;
            }

            .contact-title {
                font-size: 1.5rem;
                font-weight: 600;
                margin-bottom: 15px;
                color: var(--dark-color);
                text-align: center;
            }

            .contact-text {
                color: #718096;
                text-align: center;
            }

            .section-title {
                position: relative;
                margin-bottom: 40px;
                font-weight: 700;
                color: var(--dark-color);
                padding-bottom: 15px;
            }

            .section-title::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                width: 60px;
                height: 4px;
                background: var(--primary-color);
                border-radius: 2px;
            }

            .form-control {
                height: auto;
                padding: 15px;
                border-radius: 10px;
                border: 1px solid #E2E8F0;
                margin-bottom: 10px;
                transition: all 0.3s ease;
            }

            .form-control:focus {
                border-color: var(--secondary-color);
                box-shadow: 0 0 0 0.25rem rgba(78, 205, 196, 0.25);
            }

            .form-label {
                font-weight: 500;
                color: var(--dark-color);
            }

            .btn-submit {
                background-color: var(--primary-color);
                color: white;
                border: none;
                padding: 15px 30px;
                border-radius: 10px;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .btn-submit:hover {
                background-color: #ff5252;
                transform: translateY(-3px);
                box-shadow: 0 10px 20px rgba(255, 107, 107, 0.3);
            }

            .map-container {
                height: 400px;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            }

            .map-container iframe {
                width: 100%;
                height: 100%;
                border: none;
            }

            .faq-section {
                padding: 80px 0;
                background-color: #F7FAFC;
            }

            .accordion-item {
                border: none;
                margin-bottom: 15px;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            }

            .accordion-button {
                padding: 20px;
                font-weight: 600;
                color: var(--dark-color);
                background-color: white;
            }

            .accordion-button:not(.collapsed) {
                background-color: var(--secondary-color);
                color: white;
                box-shadow: none;
            }

            .accordion-button:focus {
                box-shadow: none;
                border-color: transparent;
            }

            .accordion-body {
                padding: 20px;
                background-color: white;
            }

            /* Footer */
            footer {
                background-color: #f8f9fa;
                padding: 40px 0;
                margin-top: 60px;
            }
            .success-message {
                background-color: rgba(72, 187, 120, 0.1);
                color: var(--success-color);
                padding: 15px;
                border-radius: 10px;
                margin-bottom: 20px;
                display: none;
                border-left: 4px solid var(--success-color);
            }

            .error-message {
                background-color: rgba(245, 101, 101, 0.1);
                color: var(--error-color);
                padding: 15px;
                border-radius: 10px;
                margin-bottom: 20px;
                border-left: 4px solid var(--error-color);
            }

            @media (max-width: 768px) {
                .page-header {
                    padding: 60px 0;
                }

                .page-header h1 {
                    font-size: 2.5rem;
                }

                .contact-box {
                    margin-bottom: 30px;
                }
            }
        </style>
    </head>
    <body>
        <%!
            public void sendContactEmail(String name, String email, String phone, String subject, String message) throws Exception {
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
            
                // Email đến admin
                Message adminMessage = new MimeMessage(session);
                adminMessage.setFrom(new InternetAddress(fromEmail));
                adminMessage.setRecipients(Message.RecipientType.TO, InternetAddress.parse(fromEmail)); // Gửi đến email admin
                adminMessage.setSubject("[new contact] " + subject);
            
                String adminEmailContent = "Thông tin liên hệ mới:<br><br>"
                    + "<b>Họ và tên:</b> " + name + "<br>"
                    + "<b>Email:</b> " + email + "<br>"
                    + "<b>Số điện thoại:</b> " + (phone != null && !phone.isEmpty() ? phone : "Không cung cấp") + "<br>"
                    + "<b>Chủ đề:</b> " + subject + "<br>"
                    + "<b>Nội dung:</b> <br>" + message.replace("\n", "<br>");
            
                adminMessage.setContent(adminEmailContent, "text/html; charset=UTF-8");
                Transport.send(adminMessage);
            
                // Email xác nhận đến khách hàng
                Message customerMessage = new MimeMessage(session);
                customerMessage.setFrom(new InternetAddress(fromEmail, "Kingdoms Toys"));
                customerMessage.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
                customerMessage.setSubject("reply from Kingdoms Toys");
            
                String customerEmailContent = "Xin chào " + name + ",<br><br>"
                    + "Cảm ơn bạn đã liên hệ với Kingdoms Toys. Chúng tôi đã nhận được tin nhắn của bạn với nội dung:<br><br>"
                    + "<i>\"" + message + "\"</i><br><br>"
                    + "Chúng tôi sẽ phản hồi trong thời gian sớm nhất có thể.<br><br>"
                    + "Trân trọng,<br>"
                    + "Đội ngũ Kingdoms Toys<br><br>"
                    + "<small>Đây là email tự động, vui lòng không trả lời email này.</small>";
            
                customerMessage.setContent(customerEmailContent, "text/html; charset=UTF-8");
                Transport.send(customerMessage);
            }
        %>

       

        <!-- Page Header -->
        <div class="page-header">
            <div class="container">
                <h1 data-aos="fade-up">Liên Hệ Với Chúng Tôi</h1>
                <nav aria-label="breadcrumb" data-aos="fade-up" data-aos-delay="100">
                    <ol class="breadcrumb justify-content-center">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Liên hệ</li>
                    </ol>
                </nav>
            </div>
        </div>

        <!-- Contact Info Section -->
        <section class="contact-section">
            <div class="container">
                <div class="row mb-5">
                    <div class="col-md-4 mb-4 mb-md-0" data-aos="fade-up">
                        <div class="contact-box">
                            <div class="contact-icon">
                                <i class="fas fa-map-marker-alt"></i>
                            </div>
                            <h4 class="contact-title">Địa Chỉ</h4>
                            <p class="contact-text">Hòa lạc, Thạch Thất, Hà Nội</p>
                        </div>
                    </div>

                    <div class="col-md-4 mb-4 mb-md-0" data-aos="fade-up" data-aos-delay="100">
                        <div class="contact-box">
                            <div class="contact-icon">
                                <i class="fas fa-phone-alt"></i>
                            </div>
                            <h4 class="contact-title">Điện Thoại</h4>
                            <p class="contact-text">+84 28 1234 5678</p>
                        </div>
                    </div>

                    <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
                        <div class="contact-box">
                            <div class="contact-icon">
                                <i class="fas fa-envelope"></i>
                            </div>
                            <h4 class="contact-title">Email</h4>
                            <p class="contact-text">toykingdoms088@gmail.com</p>
                        </div>
                    </div>
                </div>

                <div class="row mt-5">
                    <div class="col-lg-6 mb-5 mb-lg-0" data-aos="fade-right">
                        <h2 class="section-title">Gửi Tin Nhắn Cho Chúng Tôi</h2>

                        <%
                            String message = "";
                            boolean isSuccess = false;
                        
                            if (request.getMethod().equals("POST")) {
                                String name = request.getParameter("name");
                                String email = request.getParameter("email");
                                String phone = request.getParameter("phone");
                                String subject = request.getParameter("subject");
                                String contactMessage = request.getParameter("message");
                            
                                try {
                                    // Gửi email
                                    sendContactEmail(name, email, phone, subject, contactMessage);
                                
                                    message = "Cảm ơn bạn đã liên hệ! Chúng tôi sẽ phản hồi sớm nhất có thể.";
                                    isSuccess = true;
                                } catch (Exception e) {
                                    message = "Có lỗi xảy ra khi gửi tin nhắn: " + e.getMessage();
                                    isSuccess = false;
                                    e.printStackTrace();
                                }
                            }
                        
                            if (!message.isEmpty()) {
                        %>
                        <div class="<%= isSuccess ? "success-message" : "error-message" %>" style="display: block;">
                            <i class="fas fa-<%= isSuccess ? "check-circle" : "exclamation-circle" %> me-2"></i>
                            <%= message %>
                        </div>
                        <% } %>

                        <!-- Thay đổi action của form -->
                        <form id="contactForm" action="${pageContext.request.contextPath}/contact.jsp" method="POST">
                            <!-- Nội dung form không thay đổi -->
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="name">Họ và tên <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="name" name="name" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="email">Email <span class="text-danger">*</span></label>
                                        <input type="email" class="form-control" id="email" name="email" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="phone">Số điện thoại</label>
                                        <input type="tel" class="form-control" id="phone" name="phone">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="subject">Chủ đề <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="subject" name="subject" required>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="form-group">
                                        <label for="message">Nội dung <span class="text-danger">*</span></label>
                                        <textarea class="form-control" id="message" name="message" rows="5" required></textarea>
                                    </div>
                                </div>
                                <div class="col-12 text-center">
                                    <button type="submit" class="btn btn-primary btn-lg">Gửi tin nhắn</button>
                                </div>
                            </div>
                        </form>

                    </div>

                    <div class="col-lg-6" data-aos="fade-left">
                        <h2 class="section-title">Vị Trí Của Chúng Tôi</h2>
                        <div class="map-container">
                            <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3724.5063419425246!2d105.52271427595468!3d21.012416680632814!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3135abc60e7d3f19%3A0x2be9d7d0b5abcbf4!2zVHLGsOG7nW5nIMSQ4bqhaSBo4buNYyBGUFQgSMOgIE7hu5lp!5e0!3m2!1svi!2s!4v1740594863053!5m2!1svi!2s" width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
                        </div>

                        <div class="mt-4">
                            <h4 class="mb-3">Giờ làm việc</h4>
                            <p><i class="far fa-clock me-2"></i>Thứ Hai - Thứ Sáu: 8:00 - 17:30</p>
                            <p><i class="far fa-clock me-2"></i>Thứ Bảy: 8:00 - 12:00</p>
                            <p><i class="far fa-clock me-2"></i>Chủ Nhật: Đóng cửa</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- FAQ Section -->
        <section class="faq-section">
            <div class="container">
                <h2 class="text-center mb-5" data-aos="fade-up">Câu Hỏi Thường Gặp</h2>

                <div class="row justify-content-center">
                    <div class="col-lg-8" data-aos="fade-up" data-aos-delay="100">
                        <div class="accordion" id="faqAccordion">
                            <div class="accordion-item">
                                <h2 class="accordion-header" id="headingOne">
                                    <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                        Kingdoms Toys có chính sách đổi trả không?
                                    </button>
                                </h2>
                                <div id="collapseOne" class="accordion-collapse collapse show" aria-labelledby="headingOne" data-bs-parent="#faqAccordion">
                                    <div class="accordion-body">
                                        Có, chúng tôi có chính sách đổi trả trong vòng 7 ngày kể từ ngày mua hàng. Sản phẩm phải còn nguyên vẹn, chưa qua sử dụng và còn đầy đủ bao bì, phụ kiện kèm theo. Vui lòng liên hệ với chúng tôi qua email hoặc hotline để được hướng dẫn cụ thể.
                                    </div>
                                </div>
                            </div>

                            <div class="accordion-item">
                                <h2 class="accordion-header" id="headingTwo">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                        Phí vận chuyển được tính như thế nào?
                                    </button>
                                </h2>
                                <div id="collapseTwo" class="accordion-collapse collapse" aria-labelledby="headingTwo" data-bs-parent="#faqAccordion">
                                    <div class="accordion-body">
                                        Phí vận chuyển sẽ được tính dựa trên khoảng cách, trọng lượng và kích thước của sản phẩm. Đối với đơn hàng trên 500.000đ, chúng tôi sẽ miễn phí vận chuyển trong nội thành TP.HCM. Với các khu vực khác, phí vận chuyển sẽ được hiển thị khi bạn thanh toán.
                                    </div>
                                </div>
                            </div>

                            <div class="accordion-item">
                                <h2 class="accordion-header" id="headingThree">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                        Làm thế nào để kiểm tra tình trạng đơn hàng?
                                    </button>
                                </h2>
                                <div id="collapseThree" class="accordion-collapse collapse" aria-labelledby="headingThree" data-bs-parent="#faqAccordion">
                                    <div class="accordion-body">
                                        Bạn có thể kiểm tra tình trạng đơn hàng bằng cách đăng nhập vào tài khoản của mình trên website của chúng tôi và vào mục "Đơn hàng của tôi". Ngoài ra, bạn cũng sẽ nhận được email thông báo khi đơn hàng được xác nhận, khi đơn hàng được giao cho đơn vị vận chuyển và khi đơn hàng đã được giao thành công.
                                    </div>
                                </div>
                            </div>

                            <div class="accordion-item">
                                <h2 class="accordion-header" id="headingFour">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseFour" aria-expanded="false" aria-controls="collapseFour">
                                        Các sản phẩm của Kingdoms Toys có an toàn cho trẻ em không?
                                    </button>
                                </h2>
                                <div id="collapseFour" class="accordion-collapse collapse" aria-labelledby="headingFour" data-bs-parent="#faqAccordion">
                                    <div class="accordion-body">
                                        Tất cả sản phẩm của chúng tôi đều đạt tiêu chuẩn an toàn quốc tế và được kiểm định chất lượng nghiêm ngặt. Chúng tôi cam kết chỉ cung cấp những sản phẩm an toàn, không chứa các chất độc hại và phù hợp với độ tuổi được khuyến nghị. Mỗi sản phẩm đều có thông tin chi tiết về độ tuổi phù hợp và cảnh báo an toàn (nếu có).
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer>
            <div class="footer-content">
                <div class="container-fluid p-0">
                    <div class="container py-5">
                        <div class="row g-4">
                            <div class="col-lg-4 col-md-6">
                                <h5 class="mb-4" style="color: var(--text-color);">Về Kingdoms Toys</h5>
                                <div class="footer-about">
                                    <img src="${pageContext.request.contextPath}/resources/logo.png" 
                                         alt="Kingdoms Toys" 
                                         class="mb-3" 
                                         style="max-height: 60px;">
                                    <p class="mb-4">Chúng tôi là đơn vị chuyên cung cấp các sản phẩm đồ chơi chất lượng cao, 
                                        mang đến niềm vui và trải nghiệm tuyệt vời cho người sưu tầm.</p>
                                    <div class="social-links">
                                        <a href="#" class="me-3 text-decoration-none">
                                            <i class="bi bi-facebook fs-5"></i>
                                        </a>
                                        <a href="#" class="me-3 text-decoration-none">
                                            <i class="bi bi-instagram fs-5"></i>
                                        </a>
                                        <a href="#" class="me-3 text-decoration-none">
                                            <i class="bi bi-tiktok fs-5"></i>
                                        </a>
                                        <a href="#" class="text-decoration-none">
                                            <i class="bi bi-youtube fs-5"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-4 col-md-6">
                                <h5 class="mb-4" style="color: var(--text-color);">Liên kết nhanh</h5>
                                <div class="row">
                                    <div class="col-6">
                                        <ul class="list-unstyled footer-links">
                                            <li class="mb-2">
                                                <a href="#" class="text-decoration-none text-secondary">
                                                    <i class="bi bi-chevron-right me-2"></i>Trang chủ
                                                </a>
                                            </li>
                                            <li class="mb-2">
                                                <a href="#" class="text-decoration-none text-secondary">
                                                    <i class="bi bi-chevron-right me-2"></i>Sản phẩm
                                                </a>
                                            </li>
                                            <li class="mb-2">
                                                <a href="#" class="text-decoration-none text-secondary">
                                                    <i class="bi bi-chevron-right me-2"></i>Về chúng tôi
                                                </a>
                                            </li>
                                            <li class="mb-2">
                                                <a href="#" class="text-decoration-none text-secondary">
                                                    <i class="bi bi-chevron-right me-2"></i>Liên hệ
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="col-6">
                                        <ul class="list-unstyled footer-links">
                                            <li class="mb-2">
                                                <a href="#" class="text-decoration-none text-secondary">
                                                    <i class="bi bi-chevron-right me-2"></i>Chính sách
                                                </a>
                                            </li>
                                            <li class="mb-2">
                                                <a href="#" class="text-decoration-none text-secondary">
                                                    <i class="bi bi-chevron-right me-2"></i>Điều khoản
                                                </a>
                                            </li>
                                            <li class="mb-2">
                                                <a href="#" class="text-decoration-none text-secondary">
                                                    <i class="bi bi-chevron-right me-2"></i>FAQs
                                                </a>
                                            </li>
                                            <li class="mb-2">
                                                <a href="#" class="text-decoration-none text-secondary">
                                                    <i class="bi bi-chevron-right me-2"></i>Blog
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-4 col-md-6">
                                <h5 class="mb-4" style="color: var(--text-color);">Thông tin liên hệ</h5>
                                <div class="footer-contact">
                                    <div class="d-flex mb-3">
                                        <i class="bi bi-geo-alt-fill me-3 fs-5"></i>
                                        <p class="mb-0">Hòa lạc, Thạch Thất, Hà Nội</p>
                                    </div>
                                    <div class="d-flex mb-3">
                                        <i class="bi bi-envelope-fill me-3 fs-5"></i>
                                        <p class="mb-0">info@findingunicorn.com</p>
                                    </div>
                                    <div class="d-flex mb-3">
                                        <i class="bi bi-telephone-fill me-3 fs-5"></i>
                                        <p class="mb-0">(84) 123-456-789</p>
                                    </div>
                                    <div class="d-flex">
                                        <i class="bi bi-clock-fill me-3 fs-5"></i>
                                        <div>
                                            <p class="mb-0">Thứ 2 - Thứ 6: 09:00 - 21:00</p>
                                            <p class="mb-0">Thứ 7 - Chủ nhật: 09:00 - 18:00</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Copyright -->
            <div class="footer-copyright">
                <div class="container-fluid p-0">
                    <div class="container">
                        <div class="row py-3">
                            <div class="col-md-6 text-center text-md-start">
                                <p class="mb-0">&copy; 2025 Kingdoms Toys. All rights reserved.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </footer>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- AOS Animation JS -->
        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>

        <!-- Custom JS -->
        <script>
                    // Initialize AOS
                    AOS.init({
                        duration: 800,
                        easing: 'ease-in-out',
                        once: true
                    });

                    // Form validation
                    document.getElementById('contactForm').addEventListener('submit', function (event) {
                        let valid = true;
                        const name = document.getElementById('name').value;
                        const email = document.getElementById('email').value;
                        const subject = document.getElementById('subject').value;
                        const message = document.getElementById('message').value;

                        if (!name || !email || !subject || !message) {
                            valid = false;
                        }

                        if (!valid) {
                            event.preventDefault();
                            alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
                        }
                    });
        </script>
    </body>
</html>
