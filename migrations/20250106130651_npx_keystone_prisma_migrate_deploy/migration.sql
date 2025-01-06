/*
  Warnings:

  - You are about to drop the column `client` on the `Payment` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE `Payment` DROP FOREIGN KEY `Payment_client_fkey`;

-- AlterTable
ALTER TABLE `Payment` DROP COLUMN `client`;

-- CreateTable
CREATE TABLE `_Payment_client` (
    `A` VARCHAR(191) NOT NULL,
    `B` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `_Payment_client_AB_unique`(`A`, `B`),
    INDEX `_Payment_client_B_index`(`B`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `_Payment_client` ADD CONSTRAINT `_Payment_client_A_fkey` FOREIGN KEY (`A`) REFERENCES `Client`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `_Payment_client` ADD CONSTRAINT `_Payment_client_B_fkey` FOREIGN KEY (`B`) REFERENCES `Payment`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
