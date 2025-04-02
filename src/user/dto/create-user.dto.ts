import { ApiProperty } from '@nestjs/swagger';

enum UserRole {
  ADMIN = 'ADMIN',
  SUPER_ADMIN = 'SUPER_ADMIN',
}

export class CreateUserDto {
  @ApiProperty({ example: 'Abdulboriy Mahamatjanov' })
  fullName: string;

  @ApiProperty({ example: 'abdulborimahammadjanov86@gmail.com' })
  email: string;

  @ApiProperty({ example: 'admin1234' })
  password: string;

  @ApiProperty({ example: 'SUPER_ADMIN' })
  role: UserRole;
}
