import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { CreateRegionDto } from './dto/create-region.dto';
import { UpdateRegionDto } from './dto/update-region.dto';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class RegionService {
  constructor(private prisma: PrismaService) {}

  async create(createRegionDto: CreateRegionDto) {
    try {
      const newRegion = await this.prisma.region.create({
        data: createRegionDto,
      });

      return { newRegion };
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }

  async findAll() {
    try {
      const regions = await this.prisma.region.findMany();
      if (!regions.length) return { message: 'Regions table empty' };

      return { regions };
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }

  async findOne(id: string) {
    try {
      const region = await this.prisma.region.findFirst({ where: { id } });

      if (!region) throw new NotFoundException('Region not found❗');

      return { region };
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }

  async update(id: string, updateRegionDto: UpdateRegionDto) {
    try {
      const findRegion = await this.prisma.region.findFirst({ where: { id } });
      if (!findRegion) throw new NotFoundException('Region not found ❗');

      const newRegion = await this.prisma.region.update({
        where: { id },
        data: updateRegionDto,
      });

      return { newRegion };
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }

  async remove(id: string) {
    try {
      const findRegion = await this.prisma.region.findFirst({ where: { id } });
      if (!findRegion) throw new NotFoundException('Region not found ❗');

      await this.prisma.region.delete({ where: { id } });
      return { message: 'Region is successfully deleted ✅' };
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }
}
