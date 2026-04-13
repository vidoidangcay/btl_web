package controller;

import dal.DAO;
import model.Products;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet(name = "DetailServlet", urlPatterns = {"/detail"})
public class DetailServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        DAO dao = new DAO();
        Products p = dao.getProductById(id); // bạn phải có hàm này

        request.setAttribute("detail", p);
        request.getRequestDispatcher("detail.jsp").forward(request, response);
    }
}