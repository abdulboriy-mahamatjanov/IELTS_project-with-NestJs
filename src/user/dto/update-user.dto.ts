import { ApiProperty, PartialType } from '@nestjs/swagger';
import { CreateUserDto } from './create-user.dto';

enum UserRole {
  ADMIN = 'ADMIN',
  SUPER_ADMIN = 'SUPER_ADMIN',
}

export class UpdateUserDto extends PartialType(CreateUserDto) {
  @ApiProperty({ example: 'Abdulboriy Mahamatjanov' })
  fullName: string;

  @ApiProperty({ example: 'abdulborimahammadjanov86@gmail.com' })
  email: string;

  @ApiProperty({ example: 'admin1234' })
  password: string;

  @ApiProperty({ example: 'ADMIN' })
  role: UserRole;
}
