import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class UserService {
  constructor(private prisma: PrismaService) {}

  async create(createUserDto: CreateUserDto) {
    try {
      const findAdmin = await this.prisma.admins.findUnique({
        where: { email: createUserDto.email },
      });

      if (findAdmin) throw new ForbiddenException( `This ${findAdmin.email} account already exists ❗` );

      const newAdmin = await this.prisma.admins.create({ data: createUserDto });
      return { newAdmin };
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }

  async findAll() {
    try {
      const admins = await this.prisma.admins.findMany();
      if (!admins.length) return { message: 'Admins table empty' };

      return { admins };
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }

  async findOne(id: string) {
    try {
      const admin = await this.prisma.admins.findFirst({ where: { id } });
      if (!admin) throw new NotFoundException('Admin not found ❗');

      return { admin };
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }

  async update(id: string, updateUserDto: UpdateUserDto) {
    try {
      const findAdmin = await this.prisma.admins.findFirst({ where: { id } });
      if (!findAdmin) throw new NotFoundException('Admin not found ❗');

      const newAdmin = await this.prisma.admins.update({
        data: updateUserDto,
        where: { id },
      });

      return { newAdmin };
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }

  async remove(id: string) {
    try {
      const findAdmin = await this.prisma.admins.findFirst({ where: { id } });
      if (!findAdmin) throw new NotFoundException('Admin not found ❗');

      await this.prisma.admins.delete({ where: { id } });
      return { message: `${findAdmin.role} is successfully deleted ✅` };
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }
}