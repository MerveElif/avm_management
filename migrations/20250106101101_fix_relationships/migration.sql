/*
  Warnings:

  - You are about to drop the column `payments` on the `Client` table. All the data in the column will be lost.
  - You are about to drop the column `store` on the `Client` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[email]` on the table `Client` will be added. If there are existing duplicate values, this will fail.

*/
-- DropForeignKey
ALTER TABLE `Client` DROP FOREIGN KEY `Client_payments_fkey`;

-- DropForeignKey
ALTER TABLE `Client` DROP FOREIGN KEY `Client_store_fkey`;

-- DropIndex
DROP INDEX `Client_payments_key` ON `Client`;

-- AlterTable
ALTER TABLE `Client` DROP COLUMN `payments`,
    DROP COLUMN `store`;

-- AlterTable
ALTER TABLE `Payment` ADD COLUMN `client` VARCHAR(191) NULL;

-- CreateTable
CREATE TABLE `_Client_stores` (
    `A` VARCHAR(191) NOT NULL,
    `B` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `_Client_stores_AB_unique`(`A`, `B`),
    INDEX `_Client_stores_B_index`(`B`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateIndex
CREATE UNIQUE INDEX `Client_email_key` ON `Client`(`email`);

-- CreateIndex
CREATE INDEX `Payment_client_idx` ON `Payment`(`client`);

-- AddForeignKey
ALTER TABLE `Payment` ADD CONSTRAINT `Payment_client_fkey` FOREIGN KEY (`client`) REFERENCES `Client`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `_Client_stores` ADD CONSTRAINT `_Client_stores_A_fkey` FOREIGN KEY (`A`) REFERENCES `Client`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `_Client_stores` ADD CONSTRAINT `_Client_stores_B_fkey` FOREIGN KEY (`B`) REFERENCES `Store`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
