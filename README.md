<h1 align="center"> Anti Fraud </h1>
<p align="center">
  <a href="https://github.com/adrianotorres/anti-fraud/actions/workflows/ruby-tests.yml"><img src="https://github.com/adrianotorres/anti-fraud/actions/workflows/ruby-tests.yml/badge.svg" alt="Ruby Tests" /></a>
</p>

### Acquirer Market and Fraud Analysis
You can check the acquirer market infos and fraud analysis on [docs](https://github.com/adrianotorres/anti-fraud/tree/main/docs) folder

# Project
The Anti-Fraud API is designed to evaluate and determine the approval status of a given transaction based on predefined rules. The following rules are implemented to enhance fraud detection:

R1.  **Reject Consecutive Transactions:**    
    -   Automatically rejects a transaction if the user attempts too many transactions in quick succession. This rule aims to identify and prevent potential fraudulent activities characterized by rapid, successive transactions.

R2.  **Reject High-Value Transactions:**   
    -   Declines transactions that exceed a specified amount within a predefined period. This rule is designed to identify and mitigate the risk associated with unusually large transactions that may indicate fraudulent behavior.

R3.  **Chargeback History Check:**
    -   Automatically rejects a transaction if the user has a history of chargebacks. It's important to note that chargeback data is not included in the transaction payload. This information is typically received days after the transaction was initially approved. The system considers a user's chargeback history as an additional factor in fraud assessment.

## Infraestructure
### Stack

 - Ruby (3.3.0)
 - Rails (7.1.3)
 - PostgreSQL
 
 ### Code Archtecture

> Testing
> This project follows a Test-Driven Development (TDD) methodology to ensure robustness, reliability, and maintainability in the development process.
> The TDD approach involves writing tests before implementing the actual functionality, enabling a systematic and iterative development cycle. The project specifically employs TDD for API endpoint development, with a focus on request tests driven by each use case.
> This project uses simplecov for coverage, so you can check the coverage after running tests

> BCDD
This project embraces a Business Component-Driven Development (BCDD) methodology to structure and organize the logic of business components within the application. BCDD emphasizes encapsulating all business logic within dedicated resources, promoting maintainability, clarity, and a clear separation of responsibilities.

> Auth
> The authentication process is facilitated through the `/auth/login` endpoint, allowing users to authenticate using their email and password. Upon successful authentication, the system issues a JWT (JSON Web Token) as a secure authentication token.
> To access secured endpoints, users must include the JWT token in the `Authorization` header of their requests. This token serves as proof of authentication.
> *WARNING*: This API does not provide a signup endpoint; users must be registered directly in the database.

### Instalation
For an optimal development experience, it is recommended to use Docker. The project offers a Docker orchestration process that streamlines development. Additional details can be found on the Dip gem website.

1. Config envs
```bash
cp .env.example .env.development
cp .env.example .env.development
```

**Using Docker:**
2. Ensure Docker is installed on your system.
3. Run the Docker orchestration process to set up the development environment.
```bash
dip provision
```
4. Access the project's Docker container for development tasks.
```bash
dip bash
```
5. Run the tests.
```bash
dip test
```
5. Run code lint
```bash
dip rubocop
```
6. Run api
```bash
dip rails s
```


**Without Docker:**

If you choose not to use Docker, follow these steps:
1.  Install Ruby on your system.
2.  Run the following commands to set up the project:

```bash
bundle install
bin/setup
```

These commands will install the required dependencies and set up the project for development.

**Note:**

-   It is strongly recommended to use Docker for a consistent and streamlined development environment.
-   Visit the Dip gem website for more information on the Docker orchestration process.

By following these installation steps, you can set up the project easily and start the development process with the recommended tools and configurations.

### Using the Api
**Versioning**
Every endpoint is preceded by `api/version`, allowing for seamless version control.

1. **Login and Obtain JWT Token:**
   - Endpoint: `POST /api/v1/auth/login`
   - Payload:
     ```json
     {
       "type": "object",
       "required": ["email", "password"],
       "properties": {
         "email": { "type": "string" },
         "password": { "type": "string" }
       }
     }
     ```
   - Upon successful login, you'll receive a JWT token.

2. **Submit Transaction:**
   - Endpoint: `POST /api/v1/transactions`
   - Authorization: Bearer Token
   - Payload:
     ```json
     {
       "type": "object",
       "required": [
         "transaction_id",
         "merchant_id",
         "user_id",
         "card_number",
         "transaction_date",
         "transaction_amount"
       ],
       "properties": {
         "transaction_id": { "type": "string" },
         "merchant_id": { "type": "string" },
         "user_id": { "type": "string" },
         "card_number": { "type": "string" },
         "transaction_date": { "type": "string", "format": "date-time" },
         "transaction_amount": { "type": "string" },
         "device_id": { "type": "string" },
         "has_cbk": { "type": "string" }
       }
     }
     ```
   - Ensure to include the obtained JWT token in the Authorization header.

