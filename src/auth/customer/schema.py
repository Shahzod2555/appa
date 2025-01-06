from pydantic import BaseModel, EmailStr, ConfigDict


class RegisterSchemaCustomer(BaseModel):
    email: EmailStr
    phone_number: str
    password: str
    first_name: str


class LoginSchemaCustomer(BaseModel):
    email: EmailStr | None = None
    phone_number: str | None = None
    password: str


class ResponseCustomer(BaseModel):
    id: int
    email: EmailStr
    phone_number: str
    first_name: str
    last_name: str | None
    middle_name: str | None

    model_config = ConfigDict(from_attributes=True)


class CurrentCustomer(BaseModel):
    phone_number: str
    email: EmailStr
