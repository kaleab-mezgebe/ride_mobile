---
trigger: manual
---

General Principles
1. Code Analysis First
Before implementing any feature, thoroughly analyze the existing codebase

Examine models, repositories, services, controllers, and configuration files

Identify existing patterns, utilities, and reusable components

Never duplicate functionality that already exists

2. DRY (Don't Repeat Yourself) Compliance
Extract common functionality into reusable utility classes/methods

Create shared components in appropriate packages (utils, common, shared)

Use inheritance and composition to avoid code duplication

Implement generic solutions when multiple similar requirements exist

3. Modular Architecture
Break down features into smallest logical units

Each class should have a single responsibility

Separate concerns into appropriate layers (controller, service, repository)

Create dedicated packages for related functionality

4. Team Collaboration Safety
Place your work in clearly named packages 
Use descriptive class names that indicate purpose and ownership

Avoid modifying core shared files without team consultation

Create feature-specific configuration when needed

Implementation Rules
5. Code Structure Requirements
src/main/java/com/niyat/ride/
├── features/
│   ├── admin/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── repositories/
│   │   ├── dtos/
│   │   └── models/
│   └── dispatcher/
│       ├── controllers/
│       ├── services/
│       ├── repositories/
│       ├── dtos/
│       └── models/
6. Error Handling Standards
Use consistent exception handling patterns

Create custom exceptions in /shared/exceptions/

Implement global exception handling where appropriate

Provide meaningful error messages and proper HTTP status codes

7. Validation Requirements
Use Jakarta Validation annotations consistently

Create custom validators when needed

Validate input at both DTO and service levels

Return comprehensive validation error responses

8. Documentation Standards
Document all public methods with Javadoc

Include @param, @return, and @throws annotations

Update Swagger/OpenAPI documentation for new endpoints

Create README.md files for complex features

9. Testing Requirements
Write unit tests for all service methods

Create integration tests for API endpoints

Maintain test coverage above 80% for new code

Place tests in parallel package structure

Specific Implementation Guidelines
10. Pagination and Filtering
Use Spring Data JPA pagination for all list endpoints

Implement generic filtering utility classes

Create reusable response objects with pagination metadata

Support common filter parameters across similar endpoints

11. Authentication and Authorization
Respect existing JWT authentication system

Use role-based annotations (@PreAuthorize) consistently

Never bypass security checks for convenience

Create proper access denied handling

12. Database Interaction
Use Spring Data JPA repositories pattern

Implement custom queries in repository interfaces

Use @Transactional appropriately on service methods

Avoid N+1 query problems with proper fetching strategies

13. API Design Consistency
Follow RESTful conventions for endpoint naming

Use consistent HTTP status codes

Maintain uniform request/response formats

Version APIs when making breaking changes

14. Performance Considerations
Implement proper indexing for frequently queried fields

Use pagination for large datasets

Consider caching for frequently accessed, rarely changed data

Avoid unnecessary database calls in loops

Feature Implementation Workflow
15. Implementation Steps for Each Feature
Analyze existing codebase for similar functionality

Create appropriate package structure in /features/

Implement models/entities first

Create repositories with necessary query methods

Implement services with business logic

Create DTOs for request/response objectsImplement controllers with proper documentation

Add necessary security configuration

Write comprehensive tests

Update API documentation

16. Code Review Checklist
Follows existing patterns and conventions

No duplication of existing functionality

Proper error handling implemented

Validation comprehensive and consistent

Security requirements met

Tests cover all scenarios

Documentation complete

Performance considerations addressed

17. Collaboration Protocol
Prefix your classes with feature area when appropriate

Use feature branches for development

Coordinate with team on shared component changes

Document breaking changes or dependencies clearly
