-- AlterTable
ALTER TABLE `Payment` ADD COLUMN `client` VARCHAR(191) NULL;

-- CreateIndex
CREATE INDEX `Payment_client_idx` ON `Payment`(`client`);

-- AddForeignKey
ALTER TABLE `Payment` ADD CONSTRAINT `Payment_client_fkey` FOREIGN KEY (`client`) REFERENCES `Client`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
