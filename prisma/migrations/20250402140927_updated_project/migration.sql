-- CreateEnum
CREATE TYPE "AdminRole" AS ENUM ('ADMIN', 'SUPER_ADMIN');

-- CreateEnum
CREATE TYPE "LearningCenterStatus" AS ENUM ('PENDING', 'ACTIVATED', 'REJECTED', 'INACTIVE');

-- CreateEnum
CREATE TYPE "TeacherStatus" AS ENUM ('ACTIVE', 'INACTIVE');

-- CreateEnum
CREATE TYPE "ReadingBlockPartNameType" AS ENUM ('PART1', 'PART2', 'PART3');

-- CreateEnum
CREATE TYPE "ReadingBlockQuestionType" AS ENUM ('MULTIPLE_CHOICE', 'TRUE_FALSE_NOT_GIVEN', 'YES_NO_NOT_GIVEN', 'MATCHING_HEADINGS', 'MATCHING_INFORMATION', 'MATCHING_FEATURES', 'MATCHING_SENTENCE_ENDINGS', 'SENTENCE_COMPLETION', 'SUMMARY_COMPLETION', 'NOTE_COMPLETION', 'DIAGRAM_LABEL_COMPLETION', 'SHORT_ANSWER', 'LIST_SELECTION', 'GLOBAL_MULTIPLE_CHOICE');

-- CreateTable
CREATE TABLE "Admins" (
    "id" TEXT NOT NULL,
    "fullName" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "role" "AdminRole" NOT NULL,

    CONSTRAINT "Admins_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Region" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Region_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LearningCenter" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "document" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    "regionId" TEXT NOT NULL,
    "image" TEXT NOT NULL,
    "status" "LearningCenterStatus" NOT NULL DEFAULT 'INACTIVE',
    "role" TEXT NOT NULL DEFAULT 'Center',

    CONSTRAINT "LearningCenter_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Teachers" (
    "id" TEXT NOT NULL,
    "fullName" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "sertificate" TEXT NOT NULL,
    "status" "TeacherStatus" NOT NULL DEFAULT 'INACTIVE',
    "avatar" TEXT NOT NULL,
    "role" TEXT NOT NULL DEFAULT 'Teacher',
    "learningcenterId" TEXT NOT NULL,

    CONSTRAINT "Teachers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Groups" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "teacherId" TEXT NOT NULL,
    "startTime" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "endTime" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "avarageScore" TEXT NOT NULL,

    CONSTRAINT "Groups_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Students" (
    "id" TEXT NOT NULL,
    "fullName" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "role" TEXT NOT NULL DEFAULT 'Student',
    "password" TEXT NOT NULL,
    "avatar" TEXT NOT NULL,
    "groupId" TEXT NOT NULL,

    CONSTRAINT "Students_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ReadingVariant" (
    "id" TEXT NOT NULL,
    "readingName" TEXT NOT NULL,
    "isReady" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "ReadingVariant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ReadingBlock" (
    "id" TEXT NOT NULL,
    "text" TEXT NOT NULL,
    "readingVariantId" TEXT NOT NULL,
    "partName" "ReadingBlockPartNameType" NOT NULL,

    CONSTRAINT "ReadingBlock_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ReadingBlockQuestions" (
    "id" TEXT NOT NULL,
    "readingBlockId" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "type" "ReadingBlockQuestionType" NOT NULL,

    CONSTRAINT "ReadingBlockQuestions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ReadingQuestions" (
    "id" TEXT NOT NULL,
    "options" TEXT[],
    "isCorrect" TEXT[],
    "questionNumber" INTEGER NOT NULL,
    "readingBlockQuestionId" TEXT NOT NULL,

    CONSTRAINT "ReadingQuestions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WritingVariant" (
    "id" TEXT NOT NULL,
    "writingName" TEXT NOT NULL,
    "isReady" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "WritingVariant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WritingBlock" (
    "id" TEXT NOT NULL,
    "task" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "image" TEXT NOT NULL,
    "writingVariantId" TEXT NOT NULL,

    CONSTRAINT "WritingBlock_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Exam" (
    "id" TEXT NOT NULL,
    "studentId" TEXT NOT NULL,
    "readingVariantId" TEXT NOT NULL,
    "writingVariantId" TEXT NOT NULL,

    CONSTRAINT "Exam_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Result" (
    "id" TEXT NOT NULL,
    "examId" TEXT NOT NULL,
    "teacherId" TEXT NOT NULL,
    "cheackerTeacherId" TEXT NOT NULL,
    "writingScore" INTEGER NOT NULL,
    "readingScore" INTEGER NOT NULL,

    CONSTRAINT "Result_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Admins_email_key" ON "Admins"("email");

-- CreateIndex
CREATE UNIQUE INDEX "LearningCenter_email_key" ON "LearningCenter"("email");

-- CreateIndex
CREATE UNIQUE INDEX "LearningCenter_phone_key" ON "LearningCenter"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "Teachers_email_key" ON "Teachers"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Teachers_phone_key" ON "Teachers"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "Students_phone_key" ON "Students"("phone");

-- AddForeignKey
ALTER TABLE "LearningCenter" ADD CONSTRAINT "LearningCenter_regionId_fkey" FOREIGN KEY ("regionId") REFERENCES "Region"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Teachers" ADD CONSTRAINT "Teachers_learningcenterId_fkey" FOREIGN KEY ("learningcenterId") REFERENCES "LearningCenter"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Groups" ADD CONSTRAINT "Groups_teacherId_fkey" FOREIGN KEY ("teacherId") REFERENCES "Teachers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Students" ADD CONSTRAINT "Students_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "Groups"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ReadingBlock" ADD CONSTRAINT "ReadingBlock_readingVariantId_fkey" FOREIGN KEY ("readingVariantId") REFERENCES "ReadingVariant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ReadingBlockQuestions" ADD CONSTRAINT "ReadingBlockQuestions_readingBlockId_fkey" FOREIGN KEY ("readingBlockId") REFERENCES "ReadingBlock"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ReadingQuestions" ADD CONSTRAINT "ReadingQuestions_readingBlockQuestionId_fkey" FOREIGN KEY ("readingBlockQuestionId") REFERENCES "ReadingBlockQuestions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WritingBlock" ADD CONSTRAINT "WritingBlock_writingVariantId_fkey" FOREIGN KEY ("writingVariantId") REFERENCES "WritingVariant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Exam" ADD CONSTRAINT "Exam_studentId_fkey" FOREIGN KEY ("studentId") REFERENCES "Students"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Exam" ADD CONSTRAINT "Exam_readingVariantId_fkey" FOREIGN KEY ("readingVariantId") REFERENCES "ReadingVariant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Exam" ADD CONSTRAINT "Exam_writingVariantId_fkey" FOREIGN KEY ("writingVariantId") REFERENCES "WritingVariant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Result" ADD CONSTRAINT "Result_examId_fkey" FOREIGN KEY ("examId") REFERENCES "Exam"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Result" ADD CONSTRAINT "Result_teacherId_fkey" FOREIGN KEY ("teacherId") REFERENCES "Teachers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Result" ADD CONSTRAINT "Result_cheackerTeacherId_fkey" FOREIGN KEY ("cheackerTeacherId") REFERENCES "Teachers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
