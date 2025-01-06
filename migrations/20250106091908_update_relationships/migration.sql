-- CreateTable
CREATE TABLE `Mall` (
    `id` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL DEFAULT '',
    `city` VARCHAR(191) NOT NULL DEFAULT '',
    `address` VARCHAR(191) NOT NULL DEFAULT '',
    `createdAt` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Store` (
    `id` VARCHAR(191) NOT NULL,
    `storeName` VARCHAR(191) NOT NULL DEFAULT '',
    `floorNumber` INTEGER NULL,
    `createdAt` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NULL,
    `mall` VARCHAR(191) NULL,
    `client` VARCHAR(191) NULL,

    INDEX `Store_mall_idx`(`mall`),
    INDEX `Store_client_idx`(`client`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Payment` (
    `id` VARCHAR(191) NOT NULL,
    `amount` DECIMAL(10, 2) NOT NULL,
    `paymentDate` DATE NOT NULL,
    `dueDate` DATE NULL,
    `paymentMethod` VARCHAR(191) NULL DEFAULT 'bank_transfer',
    `currency` VARCHAR(191) NOT NULL DEFAULT 'TRY',
    `lateFee` DECIMAL(10, 2) NULL DEFAULT 0.00,
    `status` VARCHAR(191) NULL DEFAULT 'paid',
    `receiptNumber` VARCHAR(191) NOT NULL DEFAULT '',
    `note` VARCHAR(191) NOT NULL DEFAULT '',
    `createdAt` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NULL,
    `store` VARCHAR(191) NULL,

    INDEX `Payment_store_idx`(`store`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Client` (
    `id` VARCHAR(191) NOT NULL,
    `fullName` VARCHAR(191) NOT NULL DEFAULT '',
    `phoneNumber` VARCHAR(191) NOT NULL DEFAULT '',
    `email` VARCHAR(191) NOT NULL DEFAULT '',
    `createdAt` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NULL,
    `payments` VARCHAR(191) NULL,
    `mall` VARCHAR(191) NULL,
    `store` VARCHAR(191) NULL,

    UNIQUE INDEX `Client_payments_key`(`payments`),
    INDEX `Client_mall_idx`(`mall`),
    INDEX `Client_store_idx`(`store`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `User` (
    `id` VARCHAR(191) NOT NULL,
    `fullName` VARCHAR(191) NOT NULL DEFAULT '',
    `email` VARCHAR(191) NOT NULL DEFAULT '',
    `password` VARCHAR(191) NOT NULL,
    `role` VARCHAR(191) NULL DEFAULT 'manager',
    `createdAt` DATETIME(3) NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NULL,

    UNIQUE INDEX `User_email_key`(`email`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `_Mall_managers` (
    `A` VARCHAR(191) NOT NULL,
    `B` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `_Mall_managers_AB_unique`(`A`, `B`),
    INDEX `_Mall_managers_B_index`(`B`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Store` ADD CONSTRAINT `Store_mall_fkey` FOREIGN KEY (`mall`) REFERENCES `Mall`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Store` ADD CONSTRAINT `Store_client_fkey` FOREIGN KEY (`client`) REFERENCES `Client`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Payment` ADD CONSTRAINT `Payment_store_fkey` FOREIGN KEY (`store`) REFERENCES `Store`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Client` ADD CONSTRAINT `Client_payments_fkey` FOREIGN KEY (`payments`) REFERENCES `Payment`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Client` ADD CONSTRAINT `Client_mall_fkey` FOREIGN KEY (`mall`) REFERENCES `Mall`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Client` ADD CONSTRAINT `Client_store_fkey` FOREIGN KEY (`store`) REFERENCES `Store`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `_Mall_managers` ADD CONSTRAINT `_Mall_managers_A_fkey` FOREIGN KEY (`A`) REFERENCES `Mall`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `_Mall_managers` ADD CONSTRAINT `_Mall_managers_B_fkey` FOREIGN KEY (`B`) REFERENCES `User`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
