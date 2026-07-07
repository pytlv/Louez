CREATE TYPE "public"."activity_type" AS ENUM('created', 'confirmed', 'rejected', 'cancelled', 'picked_up', 'returned', 'note_updated', 'payment_added', 'payment_updated', 'payment_received', 'payment_initiated', 'payment_failed', 'payment_expired', 'deposit_authorized', 'deposit_captured', 'deposit_released', 'deposit_failed', 'access_link_sent', 'modified', 'inspection_departure_started', 'inspection_departure_completed', 'inspection_return_started', 'inspection_return_completed', 'inspection_damage_detected', 'inspection_signed', 'quote_accepted', 'quote_declined');--> statement-breakpoint
CREATE TYPE "public"."condition_rating" AS ENUM('excellent', 'good', 'fair', 'damaged');--> statement-breakpoint
CREATE TYPE "public"."customer_type" AS ENUM('individual', 'business');--> statement-breakpoint
CREATE TYPE "public"."deposit_status" AS ENUM('none', 'pending', 'card_saved', 'authorized', 'captured', 'released', 'failed');--> statement-breakpoint
CREATE TYPE "public"."device_type" AS ENUM('mobile', 'tablet', 'desktop');--> statement-breakpoint
CREATE TYPE "public"."document_type" AS ENUM('contract', 'invoice');--> statement-breakpoint
CREATE TYPE "public"."inspection_field_type" AS ENUM('checkbox', 'rating', 'text', 'number', 'select');--> statement-breakpoint
CREATE TYPE "public"."inspection_status" AS ENUM('draft', 'completed', 'signed');--> statement-breakpoint
CREATE TYPE "public"."inspection_template_scope" AS ENUM('store', 'category', 'product');--> statement-breakpoint
CREATE TYPE "public"."inspection_type" AS ENUM('departure', 'return');--> statement-breakpoint
CREATE TYPE "public"."invitation_status" AS ENUM('pending', 'accepted', 'expired', 'cancelled');--> statement-breakpoint
CREATE TYPE "public"."member_role" AS ENUM('owner', 'member');--> statement-breakpoint
CREATE TYPE "public"."page_type" AS ENUM('home', 'catalog', 'product', 'cart', 'checkout', 'confirmation', 'account', 'rental');--> statement-breakpoint
CREATE TYPE "public"."payg_invoice_status" AS ENUM('draft', 'open', 'paid', 'failed', 'void');--> statement-breakpoint
CREATE TYPE "public"."payment_method" AS ENUM('stripe', 'cash', 'card', 'transfer', 'check', 'other');--> statement-breakpoint
CREATE TYPE "public"."payment_status" AS ENUM('pending', 'authorized', 'completed', 'failed', 'cancelled', 'refunded');--> statement-breakpoint
CREATE TYPE "public"."payment_type" AS ENUM('rental', 'deposit', 'deposit_hold', 'deposit_capture', 'deposit_return', 'damage', 'adjustment');--> statement-breakpoint
CREATE TYPE "public"."platform_fee_source" AS ENUM('online', 'manual', 'free');--> statement-breakpoint
CREATE TYPE "public"."platform_fee_status" AS ENUM('pending', 'collected', 'billed', 'voided', 'reversed');--> statement-breakpoint
CREATE TYPE "public"."pricing_mode" AS ENUM('hour', 'day', 'week');--> statement-breakpoint
CREATE TYPE "public"."product_status" AS ENUM('draft', 'active', 'archived');--> statement-breakpoint
CREATE TYPE "public"."promo_code_type" AS ENUM('percentage', 'fixed');--> statement-breakpoint
CREATE TYPE "public"."referral_reward_kind" AS ENUM('free_reservations', 'invoice_credit');--> statement-breakpoint
CREATE TYPE "public"."referral_reward_status" AS ENUM('granted', 'clawed_back');--> statement-breakpoint
CREATE TYPE "public"."reminder_audience" AS ENUM('customer', 'admin');--> statement-breakpoint
CREATE TYPE "public"."reminder_channel" AS ENUM('email', 'sms', 'discord');--> statement-breakpoint
CREATE TYPE "public"."reminder_type" AS ENUM('pickup', 'return');--> statement-breakpoint
CREATE TYPE "public"."reservation_status" AS ENUM('pending', 'confirmed', 'ongoing', 'completed', 'cancelled', 'rejected', 'quote', 'declined');--> statement-breakpoint
CREATE TYPE "public"."review_request_channel" AS ENUM('email', 'sms');--> statement-breakpoint
CREATE TYPE "public"."sms_topup_status" AS ENUM('pending', 'completed', 'failed', 'refunded');--> statement-breakpoint
CREATE TYPE "public"."storefront_event_type" AS ENUM('product_view', 'add_to_cart', 'remove_from_cart', 'update_quantity', 'checkout_started', 'checkout_completed', 'checkout_abandoned', 'payment_initiated', 'payment_completed', 'payment_failed', 'login_requested', 'login_completed');--> statement-breakpoint
CREATE TYPE "public"."subscription_status" AS ENUM('active', 'cancelled', 'past_due', 'trialing');--> statement-breakpoint
CREATE TYPE "public"."unit_downtime_reason" AS ENUM('maintenance', 'repair', 'other');--> statement-breakpoint
CREATE TYPE "public"."unit_event_type" AS ENUM('created', 'deleted', 'downtime_declared', 'downtime_updated', 'downtime_closed', 'downtime_deleted', 'retired', 'reinstated', 'assigned', 'unassigned', 'updated');--> statement-breakpoint
CREATE TYPE "public"."lifecycle_status" AS ENUM('active', 'retired');--> statement-breakpoint
CREATE TYPE "public"."retirement_reason" AS ENUM('sold', 'lost', 'broken', 'other');--> statement-breakpoint
CREATE TABLE "accounts" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"user_id" varchar(21) NOT NULL,
	"provider" varchar(255) NOT NULL,
	"provider_account_id" varchar(255) NOT NULL,
	"access_token" text,
	"refresh_token" text,
	"access_token_expires_at" timestamp,
	"refresh_token_expires_at" timestamp,
	"scope" varchar(255),
	"id_token" text,
	"password" text,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "accounts_provider_idx" UNIQUE("provider","provider_account_id")
);
--> statement-breakpoint
CREATE TABLE "admin_digest_logs" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"digest_date" varchar(10) NOT NULL,
	"channel" "reminder_channel" NOT NULL,
	"sent_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "admin_digest_logs_unique" UNIQUE("store_id","digest_date","channel")
);
--> statement-breakpoint
CREATE TABLE "ai_chat_messages" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"chat_id" varchar(21) NOT NULL,
	"role" "ai_chat_message_role" NOT NULL,
	"content" text,
	"tool_invocations" jsonb,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "ai_chats" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"user_id" varchar(21) NOT NULL,
	"title" varchar(255),
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "api_keys" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"user_id" varchar(21) NOT NULL,
	"name" varchar(100) NOT NULL,
	"key_prefix" varchar(12) NOT NULL,
	"key_hash" varchar(64) NOT NULL,
	"permissions" jsonb NOT NULL,
	"last_used_at" timestamp,
	"expires_at" timestamp,
	"revoked_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "api_keys_key_hash_unique" UNIQUE("key_hash")
);
--> statement-breakpoint
CREATE TABLE "categories" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"name" varchar(255) NOT NULL,
	"description" text,
	"image_url" text,
	"order" integer DEFAULT 0,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "customer_sessions" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"customer_id" varchar(21) NOT NULL,
	"token" varchar(255) NOT NULL,
	"expires_at" timestamp NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "customer_sessions_token_unique" UNIQUE("token")
);
--> statement-breakpoint
CREATE TABLE "customers" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"customer_type" "customer_type" DEFAULT 'individual' NOT NULL,
	"email" varchar(255) NOT NULL,
	"first_name" varchar(255) NOT NULL,
	"last_name" varchar(255) NOT NULL,
	"company_name" varchar(255),
	"phone" varchar(50),
	"address" text,
	"city" varchar(255),
	"postal_code" varchar(20),
	"country" varchar(2) DEFAULT 'FR',
	"notes" text,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "customers_unique_email_per_store" UNIQUE("store_id","email")
);
--> statement-breakpoint
CREATE TABLE "daily_stats" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"date" timestamp NOT NULL,
	"page_views" integer DEFAULT 0 NOT NULL,
	"unique_visitors" integer DEFAULT 0 NOT NULL,
	"product_views" integer DEFAULT 0 NOT NULL,
	"cart_additions" integer DEFAULT 0 NOT NULL,
	"checkout_started" integer DEFAULT 0 NOT NULL,
	"checkout_completed" integer DEFAULT 0 NOT NULL,
	"reservations_created" integer DEFAULT 0 NOT NULL,
	"reservations_confirmed" integer DEFAULT 0 NOT NULL,
	"revenue" numeric(10, 2) DEFAULT '0' NOT NULL,
	"average_cart_value" numeric(10, 2) DEFAULT '0',
	"mobile_visitors" integer DEFAULT 0 NOT NULL,
	"tablet_visitors" integer DEFAULT 0 NOT NULL,
	"desktop_visitors" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "daily_stats_unique_store_date" UNIQUE("store_id","date")
);
--> statement-breakpoint
CREATE TABLE "discord_logs" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"reservation_id" varchar(21),
	"event_type" varchar(50) NOT NULL,
	"status" varchar(20) DEFAULT 'sent' NOT NULL,
	"error" text,
	"sent_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "documents" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"reservation_id" varchar(21) NOT NULL,
	"type" "document_type" NOT NULL,
	"number" varchar(50) NOT NULL,
	"file_url" text NOT NULL,
	"file_name" varchar(255) NOT NULL,
	"cgv_snapshot" text,
	"generated_at" timestamp DEFAULT now() NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "email_logs" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"reservation_id" varchar(21),
	"customer_id" varchar(21),
	"to" varchar(255) NOT NULL,
	"subject" varchar(500) NOT NULL,
	"template_type" varchar(50) NOT NULL,
	"message_id" varchar(255),
	"status" varchar(20) DEFAULT 'sent',
	"error" text,
	"sent_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "google_places_cache" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"place_id" varchar(255) NOT NULL,
	"name" varchar(255) NOT NULL,
	"address" text,
	"rating" numeric(2, 1),
	"review_count" integer,
	"reviews" jsonb,
	"maps_url" text,
	"fetched_at" timestamp DEFAULT now() NOT NULL,
	"expires_at" timestamp NOT NULL,
	CONSTRAINT "google_places_cache_place_id_unique" UNIQUE("place_id")
);
--> statement-breakpoint
CREATE TABLE "inspection_field_values" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"inspection_item_id" varchar(21) NOT NULL,
	"template_field_id" varchar(21) NOT NULL,
	"field_snapshot" jsonb NOT NULL,
	"checkbox_value" boolean,
	"rating_value" integer,
	"text_value" text,
	"number_value" numeric(15, 4),
	"select_value" varchar(255),
	"has_issue" boolean DEFAULT false NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "inspection_items" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"inspection_id" varchar(21) NOT NULL,
	"reservation_item_id" varchar(21) NOT NULL,
	"product_unit_id" varchar(21),
	"product_snapshot" jsonb NOT NULL,
	"overall_condition" "condition_rating",
	"notes" text,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "inspection_photos" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"inspection_item_id" varchar(21) NOT NULL,
	"field_value_id" varchar(21),
	"photo_key" varchar(255) NOT NULL,
	"photo_url" text NOT NULL,
	"thumbnail_key" varchar(255),
	"thumbnail_url" text,
	"caption" text,
	"display_order" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "inspection_template_fields" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"template_id" varchar(21) NOT NULL,
	"name" varchar(255) NOT NULL,
	"description" text,
	"field_type" "inspection_field_type" NOT NULL,
	"options" jsonb,
	"rating_min" integer DEFAULT 1,
	"rating_max" integer DEFAULT 5,
	"number_unit" varchar(50),
	"is_required" boolean DEFAULT false NOT NULL,
	"section_name" varchar(100),
	"display_order" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "inspection_templates" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"scope" "inspection_template_scope" NOT NULL,
	"category_id" varchar(21),
	"product_id" varchar(21),
	"name" varchar(255) NOT NULL,
	"description" text,
	"is_active" boolean DEFAULT true NOT NULL,
	"display_order" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "inspection_templates_unique_scope" UNIQUE("store_id","scope","category_id","product_id")
);
--> statement-breakpoint
CREATE TABLE "inspections" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"reservation_id" varchar(21) NOT NULL,
	"type" "inspection_type" NOT NULL,
	"status" "inspection_status" DEFAULT 'draft' NOT NULL,
	"template_id" varchar(21),
	"template_snapshot" jsonb,
	"notes" text,
	"performed_by_id" varchar(21),
	"performed_at" timestamp,
	"customer_signature" text,
	"signed_at" timestamp,
	"signature_ip" varchar(50),
	"has_damage" boolean DEFAULT false NOT NULL,
	"damage_description" text,
	"estimated_damage_cost" numeric(10, 2),
	"damage_payment_id" varchar(21),
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "inspections_unique_type" UNIQUE("reservation_id","type")
);
--> statement-breakpoint
CREATE TABLE "integration_credentials" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"integration_id" varchar(21) NOT NULL,
	"credential_kind" "credential_kind" DEFAULT 'oauth' NOT NULL,
	"access_token_encrypted" text,
	"refresh_token_encrypted" text,
	"expires_at" timestamp,
	"scopes" text,
	"key_version" integer DEFAULT 1 NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "integration_credentials_integration_unique" UNIQUE("integration_id")
);
--> statement-breakpoint
CREATE TABLE "page_views" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"session_id" varchar(36) NOT NULL,
	"page" "page_type" NOT NULL,
	"product_id" varchar(21),
	"category_id" varchar(21),
	"referrer" varchar(500),
	"device" "device_type" DEFAULT 'desktop',
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "pay_as_you_go_invoices" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"billing_month" varchar(7) NOT NULL,
	"location_count" integer DEFAULT 0 NOT NULL,
	"gross_amount_cents" integer DEFAULT 0 NOT NULL,
	"collected_at_source_cents" integer DEFAULT 0 NOT NULL,
	"invoiced_amount_cents" integer DEFAULT 0 NOT NULL,
	"currency" varchar(3) DEFAULT 'eur' NOT NULL,
	"status" "payg_invoice_status" DEFAULT 'draft' NOT NULL,
	"stripe_invoice_id" varchar(255),
	"stripe_customer_id" varchar(255),
	"created_at" timestamp DEFAULT now() NOT NULL,
	"paid_at" timestamp,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "payg_invoices_store_month_unique" UNIQUE("store_id","billing_month")
);
--> statement-breakpoint
CREATE TABLE "payment_requests" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"reservation_id" varchar(21) NOT NULL,
	"token" varchar(64) NOT NULL,
	"amount" numeric(10, 2) NOT NULL,
	"currency" varchar(3) DEFAULT 'EUR' NOT NULL,
	"description" varchar(255) NOT NULL,
	"type" "payment_request_type" NOT NULL,
	"status" "payment_request_status" DEFAULT 'pending' NOT NULL,
	"expires_at" timestamp NOT NULL,
	"completed_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "payment_requests_token_unique" UNIQUE("token")
);
--> statement-breakpoint
CREATE TABLE "payments" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"reservation_id" varchar(21) NOT NULL,
	"amount" numeric(10, 2) NOT NULL,
	"type" "payment_type" NOT NULL,
	"method" "payment_method" NOT NULL,
	"status" "payment_status" DEFAULT 'pending' NOT NULL,
	"stripe_payment_intent_id" varchar(255),
	"stripe_charge_id" varchar(255),
	"stripe_checkout_session_id" varchar(255),
	"stripe_refund_id" varchar(255),
	"stripe_payment_method_id" varchar(255),
	"authorization_expires_at" timestamp,
	"captured_amount" numeric(10, 2),
	"currency" varchar(3) DEFAULT 'EUR',
	"notes" text,
	"paid_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "platform_fee" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"reservation_id" varchar(21) NOT NULL,
	"payment_id" varchar(21),
	"dedup_key" varchar(80) NOT NULL,
	"amount_cents" integer NOT NULL,
	"amount_reversed_cents" integer DEFAULT 0 NOT NULL,
	"currency" varchar(3) DEFAULT 'eur' NOT NULL,
	"source" "platform_fee_source" NOT NULL,
	"status" "platform_fee_status" NOT NULL,
	"billing_month" varchar(7) NOT NULL,
	"monthly_index" integer,
	"stripe_payment_intent_id" varchar(255),
	"stripe_application_fee_id" varchar(255),
	"invoice_id" varchar(21),
	"created_at" timestamp DEFAULT now() NOT NULL,
	"billed_at" timestamp,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "platform_fee_dedup_key_unique" UNIQUE("dedup_key")
);
--> statement-breakpoint
CREATE TABLE "product_accessories" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"product_id" varchar(21) NOT NULL,
	"accessory_id" varchar(21) NOT NULL,
	"display_order" integer DEFAULT 0,
	"created_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "product_accessories_unique" UNIQUE("product_id","accessory_id")
);
--> statement-breakpoint
CREATE TABLE "product_pricing_tiers" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"product_id" varchar(21) NOT NULL,
	"min_duration" integer,
	"period" integer,
	"discount_percent" numeric(10, 6),
	"price" numeric(10, 2),
	"display_order" integer DEFAULT 0,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "product_pricing_tiers_unique" UNIQUE("product_id","min_duration"),
	CONSTRAINT "product_pricing_tiers_unique_period" UNIQUE("product_id","period")
);
--> statement-breakpoint
CREATE TABLE "product_seasonal_pricing" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"product_id" varchar(21) NOT NULL,
	"name" varchar(100) NOT NULL,
	"start_date" date NOT NULL,
	"end_date" date NOT NULL,
	"price" numeric(10, 2) NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "product_seasonal_pricing_tiers" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"seasonal_pricing_id" varchar(21) NOT NULL,
	"min_duration" integer,
	"period" integer,
	"discount_percent" numeric(10, 6),
	"price" numeric(10, 2),
	"display_order" integer DEFAULT 0,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "product_stats" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"product_id" varchar(21) NOT NULL,
	"date" timestamp NOT NULL,
	"views" integer DEFAULT 0 NOT NULL,
	"cart_additions" integer DEFAULT 0 NOT NULL,
	"reservations" integer DEFAULT 0 NOT NULL,
	"revenue" numeric(10, 2) DEFAULT '0' NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "product_stats_unique" UNIQUE("store_id","product_id","date")
);
--> statement-breakpoint
CREATE TABLE "product_unit_downtimes" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"product_unit_id" varchar(21) NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"reason" "unit_downtime_reason" NOT NULL,
	"starts_at" timestamp NOT NULL,
	"ends_at" timestamp,
	"note" text,
	"created_by_user_id" varchar(21),
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "product_unit_events" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"product_unit_id" varchar(21),
	"identifier_snapshot" varchar(255),
	"store_id" varchar(21) NOT NULL,
	"type" "unit_event_type" NOT NULL,
	"actor_user_id" varchar(21),
	"payload" jsonb,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "product_units" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"product_id" varchar(21) NOT NULL,
	"identifier" varchar(255) NOT NULL,
	"notes" text,
	"attributes" jsonb,
	"combination_key" varchar(255) DEFAULT '__default' NOT NULL,
	"lifecycle_status" "lifecycle_status" DEFAULT 'active' NOT NULL,
	"retired_at" timestamp,
	"retirement_reason" "retirement_reason",
	"retirement_note" text,
	"purchase_price" numeric(10, 2),
	"purchased_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "product_units_unique_identifier" UNIQUE("product_id","identifier")
);
--> statement-breakpoint
CREATE TABLE "products" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"category_id" varchar(21),
	"name" varchar(255) NOT NULL,
	"description" text,
	"images" jsonb DEFAULT '[]'::jsonb,
	"price" numeric(10, 2) NOT NULL,
	"deposit" numeric(10, 2) DEFAULT '0',
	"base_period_minutes" integer,
	"pricing_mode" "pricing_mode" NOT NULL,
	"video_url" text,
	"tax_settings" jsonb,
	"enforce_strict_tiers" boolean DEFAULT false NOT NULL,
	"quantity" integer DEFAULT 1 NOT NULL,
	"track_units" boolean DEFAULT false NOT NULL,
	"booking_attribute_axes" jsonb,
	"display_order" integer DEFAULT 0,
	"status" "product_status" DEFAULT 'active',
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "products_tulip" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"product_id" varchar(21) NOT NULL,
	"tulip_product_id" varchar(50) NOT NULL,
	CONSTRAINT "products_tulip_product_idx" UNIQUE("product_id")
);
--> statement-breakpoint
CREATE TABLE "promo_codes" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"code" varchar(50) NOT NULL,
	"description" text,
	"type" "promo_code_type" NOT NULL,
	"value" numeric(10, 2) NOT NULL,
	"minimum_amount" numeric(10, 2),
	"max_usage_count" integer,
	"current_usage_count" integer DEFAULT 0 NOT NULL,
	"starts_at" timestamp,
	"expires_at" timestamp,
	"is_active" boolean DEFAULT true NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "promo_codes_unique_code" UNIQUE("store_id","code")
);
--> statement-breakpoint
CREATE TABLE "push_subscriptions" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"user_id" varchar(21) NOT NULL,
	"store_id" varchar(21),
	"endpoint" text NOT NULL,
	"endpoint_hash" varchar(64) NOT NULL,
	"p256dh" varchar(255) NOT NULL,
	"auth" varchar(255) NOT NULL,
	"user_agent" text,
	"failure_count" integer DEFAULT 0 NOT NULL,
	"last_success_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "push_subscriptions_endpoint_unique" UNIQUE("endpoint_hash")
);
--> statement-breakpoint
CREATE TABLE "referral_rewards" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"referrer_store_id" varchar(21) NOT NULL,
	"referred_store_id" varchar(21) NOT NULL,
	"referred_user_id" varchar(21),
	"qualifying_reservation_id" varchar(21),
	"qualifying_payment_id" varchar(21),
	"qualifying_amount_cents" integer NOT NULL,
	"currency" varchar(3) DEFAULT 'eur' NOT NULL,
	"stripe_payment_intent_id" varchar(255),
	"stripe_charge_id" varchar(255),
	"stripe_invoice_item_id" varchar(255),
	"kind" "referral_reward_kind" NOT NULL,
	"free_reservations" integer DEFAULT 0 NOT NULL,
	"credit_cents" integer DEFAULT 0 NOT NULL,
	"granted_month" varchar(7) NOT NULL,
	"status" "referral_reward_status" DEFAULT 'granted' NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"clawed_back_at" timestamp,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "referral_rewards_referred_store_id_unique" UNIQUE("referred_store_id")
);
--> statement-breakpoint
CREATE TABLE "reminder_logs" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"reservation_id" varchar(21) NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"customer_id" varchar(21) NOT NULL,
	"type" "reminder_type" NOT NULL,
	"channel" "reminder_channel" NOT NULL,
	"audience" "reminder_audience" DEFAULT 'customer' NOT NULL,
	"sent_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "reminder_logs_unique" UNIQUE("reservation_id","type","channel","audience")
);
--> statement-breakpoint
CREATE TABLE "reservation_activity" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"reservation_id" varchar(21) NOT NULL,
	"user_id" varchar(21),
	"activity_type" "activity_type" NOT NULL,
	"description" text,
	"metadata" jsonb,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "reservation_calendar_events" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"reservation_id" varchar(21) NOT NULL,
	"integration_id" varchar(21) NOT NULL,
	"provider_event_id" varchar(255),
	"payload_hash" varchar(64),
	"sync_status" "sync_status" DEFAULT 'pending' NOT NULL,
	"attempt_count" integer DEFAULT 0 NOT NULL,
	"next_attempt_at" timestamp DEFAULT now() NOT NULL,
	"last_synced_at" timestamp,
	"last_error" text,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "reservation_calendar_events_reservation_integration_unique" UNIQUE("reservation_id","integration_id")
);
--> statement-breakpoint
CREATE TABLE "reservation_item_units" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"reservation_item_id" varchar(21) NOT NULL,
	"product_unit_id" varchar(21),
	"identifier_snapshot" varchar(255) NOT NULL,
	"assigned_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "reservation_item_units_unique" UNIQUE("reservation_item_id","product_unit_id")
);
--> statement-breakpoint
CREATE TABLE "reservation_items" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"reservation_id" varchar(21) NOT NULL,
	"product_id" varchar(21),
	"is_custom_item" boolean DEFAULT false NOT NULL,
	"quantity" integer NOT NULL,
	"unit_price" numeric(10, 2) NOT NULL,
	"deposit_per_unit" numeric(10, 2) NOT NULL,
	"total_price" numeric(10, 2) NOT NULL,
	"tax_rate" numeric(5, 2),
	"tax_amount" numeric(10, 2),
	"price_excl_tax" numeric(10, 2),
	"total_excl_tax" numeric(10, 2),
	"pricing_breakdown" jsonb,
	"product_snapshot" jsonb NOT NULL,
	"combination_key" varchar(255),
	"selected_attributes" jsonb,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "reservations" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"customer_id" varchar(21) NOT NULL,
	"number" varchar(50) NOT NULL,
	"status" "reservation_status" DEFAULT 'pending' NOT NULL,
	"start_date" timestamp NOT NULL,
	"end_date" timestamp NOT NULL,
	"subtotal_amount" numeric(10, 2) NOT NULL,
	"deposit_amount" numeric(10, 2) NOT NULL,
	"total_amount" numeric(10, 2) NOT NULL,
	"subtotal_excl_tax" numeric(10, 2),
	"tax_amount" numeric(10, 2),
	"tax_rate" numeric(5, 2),
	"signed_at" timestamp,
	"signature_ip" varchar(50),
	"deposit_status" "deposit_status" DEFAULT 'pending',
	"deposit_payment_intent_id" varchar(255),
	"deposit_authorization_expires_at" timestamp,
	"stripe_customer_id" varchar(255),
	"stripe_payment_method_id" varchar(255),
	"picked_up_at" timestamp,
	"returned_at" timestamp,
	"customer_notes" text,
	"internal_notes" text,
	"outbound_method" varchar(20) DEFAULT 'store' NOT NULL,
	"return_method" varchar(20) DEFAULT 'store' NOT NULL,
	"delivery_option" varchar(20) DEFAULT 'pickup',
	"delivery_address" text,
	"delivery_city" varchar(255),
	"delivery_postal_code" varchar(20),
	"delivery_country" varchar(2),
	"delivery_latitude" numeric(10, 7),
	"delivery_longitude" numeric(10, 7),
	"delivery_distance_km" numeric(8, 2),
	"delivery_fee" numeric(10, 2) DEFAULT '0',
	"return_address" text,
	"return_city" varchar(255),
	"return_postal_code" varchar(20),
	"return_country" varchar(2),
	"return_latitude" numeric(10, 7),
	"return_longitude" numeric(10, 7),
	"return_distance_km" numeric(8, 2),
	"pickup_location_id" varchar(21),
	"return_location_id" varchar(21),
	"pickup_location_snapshot" jsonb,
	"return_location_snapshot" jsonb,
	"promo_code_id" varchar(21),
	"discount_amount" numeric(10, 2) DEFAULT '0',
	"promo_code_snapshot" jsonb,
	"source" varchar(20) DEFAULT 'online',
	"tulip_insurance_opt_in" boolean,
	"tulip_insurance_amount" numeric(10, 2),
	"tulip_contract_id" varchar(50),
	"tulip_contract_status" varchar(20),
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "review_request_logs" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"reservation_id" varchar(21) NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"customer_id" varchar(21) NOT NULL,
	"channel" "review_request_channel" NOT NULL,
	"sent_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "sessions" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"token" varchar(255) NOT NULL,
	"user_id" varchar(21) NOT NULL,
	"expires_at" timestamp NOT NULL,
	"ip_address" varchar(255),
	"user_agent" text,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "sessions_token_unique" UNIQUE("token")
);
--> statement-breakpoint
CREATE TABLE "sms_credits" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"balance" integer DEFAULT 0 NOT NULL,
	"total_purchased" integer DEFAULT 0 NOT NULL,
	"total_used" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "sms_credits_store_id_unique" UNIQUE("store_id")
);
--> statement-breakpoint
CREATE TABLE "sms_logs" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"reservation_id" varchar(21),
	"customer_id" varchar(21),
	"to" varchar(50) NOT NULL,
	"message" text NOT NULL,
	"template_type" varchar(50) NOT NULL,
	"message_id" varchar(255),
	"status" varchar(20) DEFAULT 'sent',
	"error" text,
	"credit_source" varchar(20) DEFAULT 'plan',
	"sent_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "sms_topup_transactions" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"quantity" integer NOT NULL,
	"unit_price_cents" integer NOT NULL,
	"total_amount_cents" integer NOT NULL,
	"currency" varchar(3) DEFAULT 'eur' NOT NULL,
	"stripe_session_id" varchar(255),
	"stripe_payment_intent_id" varchar(255),
	"status" "sms_topup_status" DEFAULT 'pending' NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"completed_at" timestamp
);
--> statement-breakpoint
CREATE TABLE "store_calendar_integrations" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"integration_id" varchar(21) NOT NULL,
	"calendar_id" varchar(255),
	"calendar_name" varchar(255),
	"sync_pending_reservations" boolean DEFAULT true NOT NULL,
	"cancelled_reservation_behavior" "cancelled_reservation_behavior" DEFAULT 'show' NOT NULL,
	"backfill_months" integer DEFAULT 12 NOT NULL,
	"backfill_past_days" integer DEFAULT 30 NOT NULL,
	"last_sync_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "store_calendar_integrations_integration_unique" UNIQUE("integration_id")
);
--> statement-breakpoint
CREATE TABLE "store_integrations" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"provider_key" varchar(80) NOT NULL,
	"category" varchar(60) NOT NULL,
	"enabled" boolean DEFAULT false NOT NULL,
	"connected_by_user_id" varchar(21),
	"provider_account_email" varchar(255),
	"status" "store_integration_status" DEFAULT 'disabled' NOT NULL,
	"last_health_check_at" timestamp,
	"last_error_code" varchar(120),
	"last_error_message" text,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "store_integrations_store_provider_unique" UNIQUE("store_id","provider_key")
);
--> statement-breakpoint
CREATE TABLE "store_invitations" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"email" varchar(255) NOT NULL,
	"role" "member_role" DEFAULT 'member' NOT NULL,
	"token" varchar(64) NOT NULL,
	"status" "invitation_status" DEFAULT 'pending' NOT NULL,
	"invited_by" varchar(21) NOT NULL,
	"expires_at" timestamp NOT NULL,
	"accepted_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "store_invitations_token_unique" UNIQUE("token")
);
--> statement-breakpoint
CREATE TABLE "store_locations" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"name" varchar(255) NOT NULL,
	"address" text NOT NULL,
	"city" varchar(255),
	"postal_code" varchar(20),
	"country" varchar(2) DEFAULT 'FR',
	"latitude" numeric(10, 7),
	"longitude" numeric(10, 7),
	"is_active" boolean DEFAULT true NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "store_members" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"user_id" varchar(21) NOT NULL,
	"role" "member_role" DEFAULT 'member' NOT NULL,
	"added_by" varchar(21),
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "store_members_unique" UNIQUE("store_id","user_id")
);
--> statement-breakpoint
CREATE TABLE "store_tulip_integrations" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"integration_id" varchar(21) NOT NULL,
	"renter_uid" varchar(120),
	"archived_renter_uid" varchar(120),
	"public_mode" "public_mode" DEFAULT 'optional' NOT NULL,
	"connected_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "store_tulip_integrations_integration_unique" UNIQUE("integration_id")
);
--> statement-breakpoint
CREATE TABLE "storefront_events" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"session_id" varchar(36) NOT NULL,
	"customer_id" varchar(21),
	"event_type" "storefront_event_type" NOT NULL,
	"metadata" jsonb,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "stores" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"user_id" varchar(21) NOT NULL,
	"name" varchar(255) NOT NULL,
	"slug" varchar(100) NOT NULL,
	"description" text,
	"email" varchar(255),
	"phone" varchar(50),
	"address" text,
	"latitude" numeric(10, 7),
	"longitude" numeric(10, 7),
	"logo_url" text,
	"dark_logo_url" text,
	"settings" jsonb DEFAULT '{"reservationMode":"payment","minRentalMinutes":60,"maxRentalMinutes":null,"advanceNoticeMinutes":1440,"turnoverBufferMinutes":0}'::jsonb,
	"theme" jsonb DEFAULT '{"mode":"light","primaryColor":"#0066FF"}'::jsonb,
	"cgv" text,
	"legal_notice" text,
	"include_cgv_in_contract" boolean DEFAULT false NOT NULL,
	"stripe_account_id" varchar(255),
	"stripe_onboarding_complete" boolean DEFAULT false,
	"stripe_charges_enabled" boolean DEFAULT false,
	"email_settings" jsonb DEFAULT '{"confirmationEnabled":true,"reminderPickupEnabled":true,"reminderReturnEnabled":true,"replyToEmail":null}'::jsonb,
	"review_booster_settings" jsonb,
	"notification_settings" jsonb,
	"discord_webhook_url" varchar(500),
	"owner_phone" varchar(20),
	"customer_notification_settings" jsonb,
	"ics_token" varchar(32),
	"referral_code" varchar(12),
	"referred_by_user_id" varchar(21),
	"referred_by_store_id" varchar(21),
	"trial_days" integer DEFAULT 0 NOT NULL,
	"discount_percent" integer DEFAULT 0 NOT NULL,
	"discount_duration_months" integer DEFAULT 0 NOT NULL,
	"stripe_coupon_id" varchar(255),
	"onboarding_completed" boolean DEFAULT false,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "stores_slug_unique" UNIQUE("slug"),
	CONSTRAINT "stores_referral_code_unique" UNIQUE("referral_code")
);
--> statement-breakpoint
CREATE TABLE "subscriptions" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"plan_slug" varchar(50) DEFAULT 'pay_as_you_go' NOT NULL,
	"billing_mode" "billing_mode" DEFAULT 'pay_as_you_go' NOT NULL,
	"pay_as_you_go_config" jsonb,
	"free_reservations_granted" integer DEFAULT 0 NOT NULL,
	"status" "subscription_status" DEFAULT 'active' NOT NULL,
	"stripe_subscription_id" varchar(255),
	"stripe_customer_id" varchar(255),
	"current_period_end" timestamp,
	"cancel_at_period_end" boolean DEFAULT false,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "subscriptions_store_id_unique" UNIQUE("store_id"),
	CONSTRAINT "subscriptions_stripe_subscription_id_unique" UNIQUE("stripe_subscription_id")
);
--> statement-breakpoint
CREATE TABLE "users" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"email" varchar(255) NOT NULL,
	"name" varchar(255),
	"image" text,
	"email_verified" boolean DEFAULT false NOT NULL,
	"acquisition_channel" varchar(32),
	"acquisition_channel_other" varchar(255),
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "users_email_unique" UNIQUE("email")
);
--> statement-breakpoint
CREATE TABLE "verification" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"identifier" varchar(255) NOT NULL,
	"value" varchar(255) NOT NULL,
	"expires_at" timestamp NOT NULL,
	"created_at" timestamp DEFAULT now(),
	"updated_at" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "verification_codes" (
	"id" varchar(21) PRIMARY KEY NOT NULL,
	"email" varchar(255) NOT NULL,
	"store_id" varchar(21) NOT NULL,
	"code" varchar(6) NOT NULL,
	"type" varchar(20) NOT NULL,
	"token" varchar(255),
	"reservation_id" varchar(21),
	"expires_at" timestamp NOT NULL,
	"used_at" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "product_unit_downtimes" ADD CONSTRAINT "product_unit_downtimes_product_unit_id_product_units_id_fk" FOREIGN KEY ("product_unit_id") REFERENCES "public"."product_units"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "product_unit_events" ADD CONSTRAINT "product_unit_events_product_unit_id_product_units_id_fk" FOREIGN KEY ("product_unit_id") REFERENCES "public"."product_units"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "products_tulip" ADD CONSTRAINT "products_tulip_product_id_products_id_fk" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "reservation_item_units" ADD CONSTRAINT "riu_reservation_item_fk" FOREIGN KEY ("reservation_item_id") REFERENCES "public"."reservation_items"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "reservation_item_units" ADD CONSTRAINT "riu_product_unit_fk" FOREIGN KEY ("product_unit_id") REFERENCES "public"."product_units"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "store_locations" ADD CONSTRAINT "store_locations_store_id_stores_id_fk" FOREIGN KEY ("store_id") REFERENCES "public"."stores"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "accounts_user_idx" ON "accounts" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "admin_digest_logs_store_idx" ON "admin_digest_logs" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "ai_chat_messages_chat_idx" ON "ai_chat_messages" USING btree ("chat_id");--> statement-breakpoint
CREATE INDEX "ai_chats_store_user_idx" ON "ai_chats" USING btree ("store_id","user_id");--> statement-breakpoint
CREATE INDEX "api_keys_store_idx" ON "api_keys" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "api_keys_prefix_idx" ON "api_keys" USING btree ("key_prefix");--> statement-breakpoint
CREATE INDEX "categories_store_idx" ON "categories" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "customers_store_idx" ON "customers" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "customers_email_idx" ON "customers" USING btree ("email");--> statement-breakpoint
CREATE INDEX "daily_stats_store_idx" ON "daily_stats" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "daily_stats_date_idx" ON "daily_stats" USING btree ("date");--> statement-breakpoint
CREATE INDEX "daily_stats_store_date_idx" ON "daily_stats" USING btree ("store_id","date");--> statement-breakpoint
CREATE INDEX "google_places_cache_place_id_idx" ON "google_places_cache" USING btree ("place_id");--> statement-breakpoint
CREATE INDEX "google_places_cache_expires_at_idx" ON "google_places_cache" USING btree ("expires_at");--> statement-breakpoint
CREATE INDEX "inspection_field_values_item_idx" ON "inspection_field_values" USING btree ("inspection_item_id");--> statement-breakpoint
CREATE INDEX "inspection_field_values_field_idx" ON "inspection_field_values" USING btree ("template_field_id");--> statement-breakpoint
CREATE INDEX "inspection_field_values_issue_idx" ON "inspection_field_values" USING btree ("inspection_item_id","has_issue");--> statement-breakpoint
CREATE INDEX "inspection_items_inspection_idx" ON "inspection_items" USING btree ("inspection_id");--> statement-breakpoint
CREATE INDEX "inspection_items_reservation_item_idx" ON "inspection_items" USING btree ("reservation_item_id");--> statement-breakpoint
CREATE INDEX "inspection_items_unit_idx" ON "inspection_items" USING btree ("product_unit_id");--> statement-breakpoint
CREATE INDEX "inspection_photos_item_idx" ON "inspection_photos" USING btree ("inspection_item_id");--> statement-breakpoint
CREATE INDEX "inspection_photos_field_value_idx" ON "inspection_photos" USING btree ("field_value_id");--> statement-breakpoint
CREATE INDEX "inspection_template_fields_template_idx" ON "inspection_template_fields" USING btree ("template_id");--> statement-breakpoint
CREATE INDEX "inspection_template_fields_order_idx" ON "inspection_template_fields" USING btree ("template_id","display_order");--> statement-breakpoint
CREATE INDEX "inspection_templates_store_idx" ON "inspection_templates" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "inspection_templates_category_idx" ON "inspection_templates" USING btree ("category_id");--> statement-breakpoint
CREATE INDEX "inspection_templates_product_idx" ON "inspection_templates" USING btree ("product_id");--> statement-breakpoint
CREATE INDEX "inspections_store_idx" ON "inspections" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "inspections_reservation_idx" ON "inspections" USING btree ("reservation_id");--> statement-breakpoint
CREATE INDEX "integration_credentials_integration_idx" ON "integration_credentials" USING btree ("integration_id");--> statement-breakpoint
CREATE INDEX "page_views_store_idx" ON "page_views" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "page_views_session_idx" ON "page_views" USING btree ("session_id");--> statement-breakpoint
CREATE INDEX "page_views_store_created_idx" ON "page_views" USING btree ("store_id","created_at");--> statement-breakpoint
CREATE INDEX "page_views_product_idx" ON "page_views" USING btree ("product_id");--> statement-breakpoint
CREATE INDEX "payg_invoices_status_idx" ON "pay_as_you_go_invoices" USING btree ("status");--> statement-breakpoint
CREATE INDEX "payg_invoices_stripe_invoice_idx" ON "pay_as_you_go_invoices" USING btree ("stripe_invoice_id");--> statement-breakpoint
CREATE INDEX "payment_requests_store_idx" ON "payment_requests" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "payment_requests_reservation_idx" ON "payment_requests" USING btree ("reservation_id");--> statement-breakpoint
CREATE INDEX "payment_requests_token_idx" ON "payment_requests" USING btree ("token");--> statement-breakpoint
CREATE INDEX "payments_reservation_idx" ON "payments" USING btree ("reservation_id");--> statement-breakpoint
CREATE INDEX "platform_fee_store_month_idx" ON "platform_fee" USING btree ("store_id","billing_month","status");--> statement-breakpoint
CREATE INDEX "platform_fee_status_idx" ON "platform_fee" USING btree ("status");--> statement-breakpoint
CREATE INDEX "platform_fee_reservation_idx" ON "platform_fee" USING btree ("reservation_id");--> statement-breakpoint
CREATE INDEX "platform_fee_payment_intent_idx" ON "platform_fee" USING btree ("stripe_payment_intent_id","status");--> statement-breakpoint
CREATE INDEX "product_accessories_product_idx" ON "product_accessories" USING btree ("product_id");--> statement-breakpoint
CREATE INDEX "product_pricing_tiers_product_idx" ON "product_pricing_tiers" USING btree ("product_id");--> statement-breakpoint
CREATE INDEX "product_seasonal_pricing_product_idx" ON "product_seasonal_pricing" USING btree ("product_id");--> statement-breakpoint
CREATE INDEX "product_seasonal_pricing_product_date_idx" ON "product_seasonal_pricing" USING btree ("product_id","start_date","end_date");--> statement-breakpoint
CREATE INDEX "seasonal_pricing_tiers_seasonal_idx" ON "product_seasonal_pricing_tiers" USING btree ("seasonal_pricing_id");--> statement-breakpoint
CREATE INDEX "product_stats_store_idx" ON "product_stats" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "product_stats_product_idx" ON "product_stats" USING btree ("product_id");--> statement-breakpoint
CREATE INDEX "product_stats_date_idx" ON "product_stats" USING btree ("date");--> statement-breakpoint
CREATE INDEX "product_unit_downtimes_unit_starts_at_idx" ON "product_unit_downtimes" USING btree ("product_unit_id","starts_at");--> statement-breakpoint
CREATE INDEX "product_unit_downtimes_store_idx" ON "product_unit_downtimes" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "product_unit_downtimes_active_at_idx" ON "product_unit_downtimes" USING btree ("store_id","starts_at","ends_at");--> statement-breakpoint
CREATE INDEX "product_unit_events_unit_created_at_idx" ON "product_unit_events" USING btree ("product_unit_id","created_at");--> statement-breakpoint
CREATE INDEX "product_units_product_idx" ON "product_units" USING btree ("product_id");--> statement-breakpoint
CREATE INDEX "product_units_lifecycle_status_idx" ON "product_units" USING btree ("product_id","lifecycle_status");--> statement-breakpoint
CREATE INDEX "product_units_lifecycle_status_combination_idx" ON "product_units" USING btree ("product_id","lifecycle_status","combination_key");--> statement-breakpoint
CREATE INDEX "products_store_idx" ON "products" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "products_category_idx" ON "products" USING btree ("category_id");--> statement-breakpoint
CREATE INDEX "products_status_idx" ON "products" USING btree ("status");--> statement-breakpoint
CREATE INDEX "products_store_status_name_idx" ON "products" USING btree ("store_id","status","name");--> statement-breakpoint
CREATE INDEX "products_tulip_tulip_product_idx" ON "products_tulip" USING btree ("tulip_product_id");--> statement-breakpoint
CREATE INDEX "promo_codes_store_idx" ON "promo_codes" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "promo_codes_active_idx" ON "promo_codes" USING btree ("store_id","is_active");--> statement-breakpoint
CREATE INDEX "push_subscriptions_user_idx" ON "push_subscriptions" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "push_subscriptions_store_idx" ON "push_subscriptions" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "referral_rewards_referrer_month_idx" ON "referral_rewards" USING btree ("referrer_store_id","granted_month");--> statement-breakpoint
CREATE INDEX "referral_rewards_charge_idx" ON "referral_rewards" USING btree ("stripe_charge_id");--> statement-breakpoint
CREATE INDEX "referral_rewards_payment_intent_idx" ON "referral_rewards" USING btree ("stripe_payment_intent_id");--> statement-breakpoint
CREATE INDEX "reminder_logs_reservation_idx" ON "reminder_logs" USING btree ("reservation_id");--> statement-breakpoint
CREATE INDEX "reminder_logs_store_idx" ON "reminder_logs" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "reservation_activity_reservation_idx" ON "reservation_activity" USING btree ("reservation_id");--> statement-breakpoint
CREATE INDEX "reservation_activity_user_idx" ON "reservation_activity" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "reservation_calendar_events_reservation_idx" ON "reservation_calendar_events" USING btree ("reservation_id");--> statement-breakpoint
CREATE INDEX "reservation_calendar_events_integration_idx" ON "reservation_calendar_events" USING btree ("integration_id");--> statement-breakpoint
CREATE INDEX "reservation_calendar_events_sync_idx" ON "reservation_calendar_events" USING btree ("sync_status","next_attempt_at");--> statement-breakpoint
CREATE INDEX "reservation_item_units_item_idx" ON "reservation_item_units" USING btree ("reservation_item_id");--> statement-breakpoint
CREATE INDEX "reservation_item_units_unit_idx" ON "reservation_item_units" USING btree ("product_unit_id");--> statement-breakpoint
CREATE INDEX "reservation_items_reservation_idx" ON "reservation_items" USING btree ("reservation_id");--> statement-breakpoint
CREATE INDEX "reservation_items_product_combination_idx" ON "reservation_items" USING btree ("product_id","combination_key");--> statement-breakpoint
CREATE INDEX "reservations_store_idx" ON "reservations" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "reservations_customer_idx" ON "reservations" USING btree ("customer_id");--> statement-breakpoint
CREATE INDEX "reservations_status_idx" ON "reservations" USING btree ("status");--> statement-breakpoint
CREATE INDEX "reservations_date_idx" ON "reservations" USING btree ("start_date","end_date");--> statement-breakpoint
CREATE INDEX "review_request_logs_reservation_idx" ON "review_request_logs" USING btree ("reservation_id");--> statement-breakpoint
CREATE INDEX "review_request_logs_store_idx" ON "review_request_logs" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "sessions_user_idx" ON "sessions" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "sessions_token_idx" ON "sessions" USING btree ("token");--> statement-breakpoint
CREATE INDEX "sms_credits_store_idx" ON "sms_credits" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "sms_topup_store_idx" ON "sms_topup_transactions" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "sms_topup_status_idx" ON "sms_topup_transactions" USING btree ("status");--> statement-breakpoint
CREATE INDEX "sms_topup_stripe_session_idx" ON "sms_topup_transactions" USING btree ("stripe_session_id");--> statement-breakpoint
CREATE INDEX "store_calendar_integrations_integration_idx" ON "store_calendar_integrations" USING btree ("integration_id");--> statement-breakpoint
CREATE INDEX "store_integrations_store_idx" ON "store_integrations" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "store_integrations_provider_idx" ON "store_integrations" USING btree ("provider_key");--> statement-breakpoint
CREATE INDEX "store_integrations_status_idx" ON "store_integrations" USING btree ("status");--> statement-breakpoint
CREATE INDEX "store_invitations_store_idx" ON "store_invitations" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "store_invitations_email_idx" ON "store_invitations" USING btree ("email");--> statement-breakpoint
CREATE INDEX "store_invitations_token_idx" ON "store_invitations" USING btree ("token");--> statement-breakpoint
CREATE INDEX "store_locations_store_idx" ON "store_locations" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "store_locations_active_idx" ON "store_locations" USING btree ("store_id","is_active");--> statement-breakpoint
CREATE INDEX "store_members_store_idx" ON "store_members" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "store_members_user_idx" ON "store_members" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "store_tulip_integrations_integration_idx" ON "store_tulip_integrations" USING btree ("integration_id");--> statement-breakpoint
CREATE INDEX "store_tulip_integrations_renter_uid_idx" ON "store_tulip_integrations" USING btree ("renter_uid");--> statement-breakpoint
CREATE INDEX "storefront_events_store_idx" ON "storefront_events" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "storefront_events_session_idx" ON "storefront_events" USING btree ("session_id");--> statement-breakpoint
CREATE INDEX "storefront_events_store_created_idx" ON "storefront_events" USING btree ("store_id","created_at");--> statement-breakpoint
CREATE INDEX "storefront_events_type_idx" ON "storefront_events" USING btree ("event_type");--> statement-breakpoint
CREATE INDEX "stores_slug_idx" ON "stores" USING btree ("slug");--> statement-breakpoint
CREATE INDEX "stores_user_idx" ON "stores" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "stores_referral_code_idx" ON "stores" USING btree ("referral_code");--> statement-breakpoint
CREATE INDEX "subscriptions_store_idx" ON "subscriptions" USING btree ("store_id");--> statement-breakpoint
CREATE INDEX "subscriptions_stripe_subscription_idx" ON "subscriptions" USING btree ("stripe_subscription_id");--> statement-breakpoint
CREATE INDEX "subscriptions_stripe_customer_idx" ON "subscriptions" USING btree ("stripe_customer_id");