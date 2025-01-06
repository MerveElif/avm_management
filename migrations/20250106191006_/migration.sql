/*
  Warnings:

  - You are about to drop the `_Payment_client` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE `_Payment_client` DROP FOREIGN KEY `_Payment_client_A_fkey`;

-- DropForeignKey
ALTER TABLE `_Payment_client` DROP FOREIGN KEY `_Payment_client_B_fkey`;

-- AlterTable
ALTER TABLE `Payment` ADD COLUMN `client` VARCHAR(191) NULL;

-- DropTable
DROP TABLE `_Payment_client`;

-- CreateIndex
CREATE INDEX `Payment_client_idx` ON `Payment`(`client`);

-- AddForeignKey
ALTER TABLE `Payment` ADD CONSTRAINT `Payment_client_fkey` FOREIGN KEY (`client`) REFERENCES `Client`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
