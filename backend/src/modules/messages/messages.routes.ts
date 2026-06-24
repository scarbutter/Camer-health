import { Router } from 'express';
import { sendMessage, getConversation, getConversationList, getUnreadCount } from './messages.controller';
import { authenticate, requireRole } from '../../middleware/auth.middleware';
import { upload } from '../../middleware/upload.middleware';

const router = Router();

router.use(authenticate, requireRole('PATIENT', 'DOCTOR'));

router.get('/', getConversationList);
router.get('/unread', getUnreadCount);
router.get('/:partnerId', getConversation);
router.post('/:receiverId', upload.single('media'), sendMessage);

export default router;
