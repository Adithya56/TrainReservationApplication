<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Preview</title>
    <style>
        /* Add your custom CSS styles here */
    </style>
</head>
<body>
    <h1>Passenger Details Preview</h1>
    <table>
        <tr>
            <th>Passenger Name</th>
            <th>Age</th>
            <th>Gender</th>
        </tr>
        <c:forEach begin="0" end="${passengerCount - 1}" varStatus="status">
            <tr>
                <td>${param['pname' + status.index]}</td>
                <td>${param['age' + status.index]}</td>
                <td>${param['gender' + status.index]}</td>
            </tr>
        </c:forEach>

        <button type="submit">Confirm</button>
    </table>
</body>
</html>