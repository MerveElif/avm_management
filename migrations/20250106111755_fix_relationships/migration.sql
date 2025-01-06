/*
  Warnings:

  - You are about to drop the column `mall` on the `Client` table. All the data in the column will be lost.
  - You are about to drop the column `client` on the `Payment` table. All the data in the column will be lost.
  - You are about to drop the column `createdAt` on the `Payment` table. All the data in the column will be lost.
  - You are about to drop the column `currency` on the `Payment` table. All the data in the column will be lost.
  - You are about to drop the column `dueDate` on the `Payment` table. All the data in the column will be lost.
  - You are about to drop the column `lateFee` on the `Payment` table. All the data in the column will be lost.
  - You are about to drop the column `note` on the `Payment` table. All the data in the column will be lost.
  - You are about to drop the column `paymentMethod` on the `Payment` table. All the data in the column will be lost.
  - You are about to drop the column `receiptNumber` on the `Payment` table. All the data in the column will be lost.
  - You are about to drop the column `updatedAt` on the `Payment` table. All the data in the column will be lost.
  - You are about to drop the column `client` on the `Store` table. All the data in the column will be lost.
  - You are about to drop the `_Client_stores` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE `Client` DROP FOREIGN KEY `Client_mall_fkey`;

-- DropForeignKey
ALTER TABLE `Payment` DROP FOREIGN KEY `Payment_client_fkey`;

-- DropForeignKey
ALTER TABLE `Store` DROP FOREIGN KEY `Store_client_fkey`;

-- DropForeignKey
ALTER TABLE `_Client_stores` DROP FOREIGN KEY `_Client_stores_A_fkey`;

-- DropForeignKey
ALTER TABLE `_Client_stores` DROP FOREIGN KEY `_Client_stores_B_fkey`;

-- AlterTable
ALTER TABLE `Client` DROP COLUMN `mall`,
    ADD COLUMN `stores` VARCHAR(191) NULL;

-- AlterTable
ALTER TABLE `Payment` DROP COLUMN `client`,
    DROP COLUMN `createdAt`,
    DROP COLUMN `currency`,
    DROP COLUMN `dueDate`,
    DROP COLUMN `lateFee`,
    DROP COLUMN `note`,
    DROP COLUMN `paymentMethod`,
    DROP COLUMN `receiptNumber`,
    DROP COLUMN `updatedAt`;

-- AlterTable
ALTER TABLE `Store` DROP COLUMN `client`;

-- DropTable
DROP TABLE `_Client_stores`;

-- CreateIndex
CREATE INDEX `Client_stores_idx` ON `Client`(`stores`);

-- AddForeignKey
ALTER TABLE `Client` ADD CONSTRAINT `Client_stores_fkey` FOREIGN KEY (`stores`) REFERENCES `Store`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
