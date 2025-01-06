from pydantic import BaseModel, EmailStr, ConfigDict


class RegisterSchemaExecutor(BaseModel):
    email: EmailStr
    phone_number: str
    password: str
    first_name: str


class LoginSchemaExecutor(BaseModel):
    email: EmailStr | None = None
    phone_number: str | None = None
    password: str


class ResponseExecutor(BaseModel):
    id: int
    email: EmailStr
    phone_number: str
    first_name: str
    last_name: str | None
    middle_name: str | None

    model_config = ConfigDict(from_attributes=True)


class CurrentExecutor(BaseModel):
    phone_number: str
    email: EmailStr
